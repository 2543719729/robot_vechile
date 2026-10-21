#!/usr/bin/env python3
"""Inspect recorded ROS1 bags without ROS. Never infer navigation success."""
import argparse
import hashlib
import json
import math
from collections import Counter
from pathlib import Path

DEFAULT_BAGS = ["2025-11-26-20-20-02.bag", "src/bobac3_slam/bobac3_gazebo_macth.bag"]


def sha256(path):
    digest = hashlib.sha256()
    with Path(path).open("rb") as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def read_odometry(reader):
    """Return bag timestamps, x/y/yaw and measured planar twist speed."""
    rows = []
    connections = [c for c in reader.connections if c.topic == "/odom"]
    if not connections:
        return rows  # An empty rosbags connection filter would read ALL topics.
    for connection, timestamp, raw in reader.messages(connections=connections):
        msg = reader.deserialize(raw, connection.msgtype)
        p, q, v = msg.pose.pose.position, msg.pose.pose.orientation, msg.twist.twist.linear
        yaw = math.atan2(2 * (q.w * q.z + q.x * q.y), 1 - 2 * (q.y**2 + q.z**2))
        row = (timestamp, p.x, p.y, yaw, math.hypot(v.x, v.y))
        if not all(math.isfinite(value) for value in row):
            raise ValueError("Non-finite odometry sample")
        rows.append(row)
    return rows


def inspect_bag(path):
    from rosbags.highlevel import AnyReader

    path = Path(path)
    with AnyReader([path]) as reader:
        counts, first, last, commands = Counter(), {}, {}, []
        for connection, timestamp, raw in reader.messages():
            topic = connection.topic
            counts[topic] += 1
            first.setdefault(topic, timestamp)
            last[topic] = timestamp
            if topic == "/cmd_vel":
                msg = reader.deserialize(raw, connection.msgtype)
                commands.append((msg.linear.x, msg.linear.y, msg.angular.z))
        if sum(counts.values()) != reader.message_count:
            raise ValueError("Bag index count does not match readable messages")
        topics = {}
        for topic, info in sorted(reader.topics.items()):
            span = (last[topic] - first[topic]) / 1e9 if counts[topic] else 0
            topics[topic] = {
                "type": info.msgtype, "messages": counts[topic],
                "observed_rate_hz": round((counts[topic] - 1) / span, 6) if span > 0 else None,
            }
        odom = read_odometry(reader)
        result = {
            "path": path.as_posix(), "sha256": sha256(path), "size_bytes": path.stat().st_size,
            "duration_s": round(reader.duration / 1e9, 6),
            "messages_read": sum(counts.values()), "topics": topics,
            "odometry": None, "command_velocity": None,
            "patrol_success_rate": None, "teb_performance_change": None,
            "limitations": [
                "No trial boundaries or paired baseline/tuned parameter snapshots are recorded.",
                "Recorded motion and topic rates do not establish task success or collision avoidance.",
                "Historical simulation/hardware provenance is not independently established by the bag filename.",
            ],
        }
        if not any(t.endswith("/goal") for t in topics):
            result["limitations"].append("Navigation action goal topic is missing.")
        if not any(t.endswith("/result") for t in topics):
            result["limitations"].append("Navigation action result topic is missing.")
        if odom:
            result["odometry"] = {
                "samples": len(odom), "coordinate_frame": "odom",
                "path_length_m": round(sum(math.hypot(b[1] - a[1], b[2] - a[2])
                                           for a, b in zip(odom, odom[1:])), 9),
                "net_displacement_m": round(math.hypot(odom[-1][1] - odom[0][1],
                                                        odom[-1][2] - odom[0][2]), 9),
                "max_reported_planar_speed_m_s": round(max(r[4] for r in odom), 9),
                "measurement": "sum of consecutive recorded /odom positions; not ground truth",
            }
        if commands:
            if not all(math.isfinite(v) for row in commands for v in row):
                raise ValueError("Non-finite command velocity")
            result["command_velocity"] = {"samples": len(commands)}
            for index, name in enumerate(("vx_m_s", "vy_m_s", "wz_rad_s")):
                result["command_velocity"][name] = {
                    "min": min(r[index] for r in commands), "max": max(r[index] for r in commands),
                }
        return result


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("bags", nargs="*", default=DEFAULT_BAGS)
    parser.add_argument("--output", default="benchmarks/results/historical_bags.json")
    parser.add_argument("--check", action="store_true", help="Verify the committed report without rewriting it")
    args = parser.parse_args()
    report = {"schema_version": 1, "evidence_type": "historical_recording_inspection",
              "bags": [inspect_bag(p) for p in args.bags]}
    output = Path(args.output)
    if args.check:
        if report != json.loads(output.read_text()):
            raise SystemExit("Recorded evidence differs from the committed report")
        print("PASS: both raw recordings reproduce the committed report")
    else:
        output.parent.mkdir(parents=True, exist_ok=True)
        output.write_text(json.dumps(report, ensure_ascii=False, indent=2, allow_nan=False) + "\n")
        print("Wrote", output)


if __name__ == "__main__":
    main()
