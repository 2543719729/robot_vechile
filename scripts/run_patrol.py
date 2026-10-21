#!/usr/bin/env python3
"""Run one ROS1 patrol trial and preserve measurements, including failures."""
import argparse
import hashlib
import json
import math
import subprocess
import threading
import time
from datetime import datetime, timezone
from pathlib import Path

import yaml
from patrol_metrics import angle_error, finite, trial_passes


def digest(data):
    return hashlib.sha256(data).hexdigest()


def canonical(data):
    return json.dumps(data, sort_keys=True, ensure_ascii=False, allow_nan=False).encode()


def wall_call(function, timeout):
    """Bound ROS-time-based waits even if /clock stops advancing."""
    result, errors = [], []
    def worker():
        try:
            result.append(function())
        except Exception as error:
            errors.append(error)
    thread = threading.Thread(target=worker, daemon=True)
    thread.start()
    thread.join(timeout)
    if thread.is_alive():
        raise TimeoutError("ROS service/topic wait exceeded wall-clock budget")
    if errors:
        raise errors[0]
    return result[0]


class OdomDistance:
    def __init__(self):
        self.lock = threading.Lock()
        self.reset()

    def reset(self):
        with self.lock:
            self.previous, self.length, self.samples, self.invalid = None, 0.0, 0, False

    def callback(self, msg):
        p = msg.pose.pose.position
        sample = (msg.header.stamp.to_sec(), p.x, p.y, msg.header.frame_id)
        with self.lock:
            self.samples += 1
            if not all(finite(v) for v in sample[:3]):
                self.invalid = True
                return
            if self.previous is not None:
                dt = sample[0] - self.previous[0]
                distance = math.hypot(sample[1] - self.previous[1], sample[2] - self.previous[2])
                if dt <= 0 or dt > .5 or distance > 1 or sample[3] != self.previous[3]:
                    self.invalid = True
                else:
                    self.length += distance
            self.previous = sample

    def value(self):
        with self.lock:
            return self.length if self.samples >= 2 and not self.invalid else None


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    for option in ("route", "map", "scenario", "trial-id", "hardware", "world-id", "output"):
        parser.add_argument("--" + option, required=True)
    parser.add_argument("--variant", choices=("baseline", "tuned"), required=True)
    parser.add_argument("--environment", choices=("simulation", "hardware"), required=True)
    parser.add_argument("--action", default="/move_base")
    parser.add_argument("--planner-ns", default="/move_base_node")
    parser.add_argument("--base-frame", default="base_footprint")
    parser.add_argument("--goal-timeout", type=float, default=60)
    parser.add_argument("--wall-timeout", type=float, default=120)
    parser.add_argument("--xy-tolerance", type=float, default=.1)
    parser.add_argument("--yaw-tolerance", type=float, default=.2)
    args = parser.parse_args()
    if not all(finite(v) and v > 0 for v in (args.goal_timeout, args.wall_timeout, args.xy_tolerance, args.yaw_tolerance)):
        parser.error("timeouts and tolerances must be positive and finite")
    output, route_path, map_path = Path(args.output), Path(args.route), Path(args.map)
    if output.exists():
        parser.error("Output already exists; never overwrite a measured attempt")
    route = yaml.safe_load(route_path.read_text())
    goals = route.get("goals", [])
    if not goals or not all(all(finite(g.get(k)) for k in ("x", "y", "yaw")) for g in goals):
        parser.error("Route must have finite x/y/yaw goals")
    map_data = yaml.safe_load(map_path.read_text())
    image_path = map_path.parent / map_data["image"]
    output.parent.mkdir(parents=True, exist_ok=True)

    import actionlib
    import rospy
    import tf
    from move_base_msgs.msg import MoveBaseAction, MoveBaseGoal
    from nav_msgs.msg import OccupancyGrid, Odometry
    rospy.init_node("measured_patrol", anonymous=True)
    client = actionlib.SimpleActionClient(args.action, MoveBaseAction)
    listener, distance = tf.TransformListener(), OdomDistance()
    subscriber = rospy.Subscriber("/odom", Odometry, distance.callback, queue_size=100)
    run = {"schema_version": 1, "evidence_type": "ros_navigation_trial",
           "run_id": "%s-%s-%s-%s" % (args.scenario, args.trial_id, args.variant, datetime.now(timezone.utc).isoformat()),
           "variant": args.variant, "scenario": args.scenario, "trial_id": args.trial_id,
           "environment": args.environment, "hardware": args.hardware, "world_id": args.world_id,
           "route_sha256": digest(route_path.read_bytes()), "map_yaml_sha256": digest(map_path.read_bytes()),
           "map_image_sha256": digest(image_path.read_bytes()), "active_map_sha256": None,
           "source_commit": subprocess.check_output(["git", "rev-parse", "HEAD"], text=True).strip(),
           "working_tree_dirty": bool(subprocess.check_output(["git", "status", "--porcelain", "--untracked-files=no"])),
           "policy": {"xy_tolerance_m": args.xy_tolerance, "yaw_tolerance_rad": args.yaw_tolerance,
                      "goal_timeout_ros_s": args.goal_timeout, "goal_timeout_wall_s": args.wall_timeout},
           "expected_goals": len(goals), "completed": False, "goals": [], "start_pose": None,
           "elapsed_ros_s": 0, "elapsed_wall_s": 0, "collision_contacts": None,
           "action_name": args.action, "planner_namespace": args.planner_ns}
    start_wall, start_ros, goal_active = time.monotonic(), rospy.Time.now().to_sec(), False

    def pose():
        stamp = listener.getLatestCommonTime(route.get("frame_id", "map"), args.base_frame)
        if rospy.Time.now().to_sec() - stamp.to_sec() > 1:
            raise RuntimeError("Localization TF is older than 1 s")
        position, rotation = listener.lookupTransform(route.get("frame_id", "map"), args.base_frame, rospy.Time(0))
        result = {"x": position[0], "y": position[1], "yaw": tf.transformations.euler_from_quaternion(rotation)[2]}
        if not all(finite(value) for value in result.values()):
            raise RuntimeError("Non-finite localization pose")
        return result

    try:
        run["use_sim_time"] = rospy.get_param("/use_sim_time", False)
        if args.environment == "simulation" and (not run["use_sim_time"] or rospy.Time.now().to_sec() <= 0):
            raise RuntimeError("Simulation requires a running /clock and use_sim_time=true")
        params = rospy.get_param(args.planner_ns)
        if not params or "TebLocalPlannerROS" not in params:
            raise RuntimeError("Actual TEB parameter namespace is missing")
        run["planner_params"] = params
        run["planner_params_sha256"] = digest(canonical(params))
        active_map = wall_call(lambda: rospy.wait_for_message("/map", OccupancyGrid), 10)
        map_snapshot = {"frame_id": active_map.header.frame_id, "resolution": active_map.info.resolution,
                        "width": active_map.info.width, "height": active_map.info.height,
                        "origin_position": [getattr(active_map.info.origin.position, k) for k in ("x", "y", "z")],
                        "origin_orientation": [getattr(active_map.info.origin.orientation, k) for k in ("x", "y", "z", "w")],
                        "data": list(active_map.data)}
        run["active_map_sha256"] = digest(canonical(map_snapshot))
        if not wall_call(lambda: client.wait_for_server(rospy.Duration(10)), 12):
            raise RuntimeError("move_base action server unavailable")
        deadline = time.monotonic() + 10
        while True:
            try:
                run["start_pose"] = pose()
                break
            except (tf.Exception, RuntimeError):
                if time.monotonic() >= deadline:
                    raise
                time.sleep(.05)
        start_wall, start_ros = time.monotonic(), rospy.Time.now().to_sec()
        for specification in goals:
            record = {"name": specification.get("name", str(len(run["goals"]))),
                      "action_status": None, "timeout": False, "xy_error_m": None,
                      "yaw_error_rad": None, "path_length_odom_m": None}
            run["goals"].append(record)
            goal = MoveBaseGoal()
            goal.target_pose.header.frame_id = route.get("frame_id", "map")
            goal.target_pose.header.stamp = rospy.Time.now()
            goal.target_pose.pose.position.x, goal.target_pose.pose.position.y = specification["x"], specification["y"]
            q = tf.transformations.quaternion_from_euler(0, 0, specification["yaw"])
            for key, value in zip(("x", "y", "z", "w"), q):
                setattr(goal.target_pose.pose.orientation, key, value)
            distance.reset()
            goal_wall, goal_ros = time.monotonic(), rospy.Time.now().to_sec()
            client.send_goal(goal)
            goal_active = True
            while not rospy.is_shutdown():
                state = client.get_state()
                if state in (2, 3, 4, 5, 8, 9):
                    record["action_status"] = int(state)
                    goal_active = False
                    break
                elapsed_ros = rospy.Time.now().to_sec() - goal_ros
                if elapsed_ros < 0:
                    raise RuntimeError("ROS clock moved backwards")
                if elapsed_ros >= args.goal_timeout or time.monotonic() - goal_wall >= args.wall_timeout:
                    record["timeout"] = True
                    record["action_status"] = int(state)
                    break
                time.sleep(.02)
            record["elapsed_ros_s"] = rospy.Time.now().to_sec() - goal_ros
            record["elapsed_wall_s"] = time.monotonic() - goal_wall
            record["path_length_odom_m"] = distance.value()
            try:
                final = pose()
                record["xy_error_m"] = math.hypot(final["x"] - specification["x"], final["y"] - specification["y"])
                record["yaw_error_rad"] = angle_error(final["yaw"], specification["yaw"])
            except (tf.Exception, RuntimeError):
                pass
            if goal_active or record["action_status"] != 3:
                break  # The failed attempt remains in the denominator.
        run["completed"] = len(run["goals"]) == len(goals) and not goal_active and not rospy.is_shutdown()
    except (Exception, KeyboardInterrupt) as error:
        run["error"] = "%s: %s" % (type(error).__name__, error)
    finally:
        if goal_active:
            try:
                client.cancel_goal()
            except Exception as error:
                run["cancel_error"] = str(error)
        run["elapsed_ros_s"] = max(0, rospy.Time.now().to_sec() - start_ros)
        run["elapsed_wall_s"] = time.monotonic() - start_wall
        run["patrol_success"] = trial_passes(run)
        with output.open("x") as stream:
            json.dump(run, stream, ensure_ascii=False, indent=2, allow_nan=False)
            stream.write("\n")
        subscriber.unregister()
        print("Saved measured attempt:", output, "success:", run["patrol_success"])
    return 0 if run["patrol_success"] else 1


if __name__ == "__main__":
    raise SystemExit(main())
