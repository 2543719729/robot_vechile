"""ROS-independent definitions for measured patrol outcomes and paired comparisons."""
import math
import statistics


def finite(value):
    return isinstance(value, (int, float)) and not isinstance(value, bool) and math.isfinite(value)


def angle_error(a, b):
    return abs(math.atan2(math.sin(a - b), math.cos(a - b)))


def goal_passes(goal, policy):
    return (goal.get("action_status") == 3 and not goal.get("timeout", False)
            and finite(goal.get("elapsed_ros_s")) and 0 <= goal["elapsed_ros_s"] <= policy["goal_timeout_ros_s"]
            and finite(goal.get("elapsed_wall_s")) and 0 <= goal["elapsed_wall_s"] <= policy["goal_timeout_wall_s"]
            and finite(goal.get("xy_error_m")) and finite(goal.get("yaw_error_rad"))
            and goal["xy_error_m"] <= policy["xy_tolerance_m"]
            and goal["yaw_error_rad"] <= policy["yaw_tolerance_rad"])


def trial_passes(run):
    return (run.get("completed") is True and not run.get("error") and run["expected_goals"] > 0
            and len(run["goals"]) == run["expected_goals"]
            and all(goal_passes(g, run["policy"]) for g in run["goals"]))


def measured_path(run):
    values = [g.get("path_length_odom_m") for g in run["goals"]]
    if len(values) != run["expected_goals"] or not values or not all(finite(v) and v >= 0 for v in values):
        return None
    return sum(values)


def compare_trials(runs):
    if not runs:
        raise ValueError("No measured trials supplied")
    pairs, identifiers, config_hashes = {}, set(), {"baseline": set(), "tuned": set()}
    for run in runs:
        if run.get("schema_version") != 1 or run.get("evidence_type") != "ros_navigation_trial":
            raise ValueError("Only run_patrol measured trial records are accepted")
        if run["run_id"] in identifiers:
            raise ValueError("Duplicate run_id: " + run["run_id"])
        identifiers.add(run["run_id"])
        variant = run["variant"]
        if variant not in config_hashes:
            raise ValueError("Variant must be baseline or tuned")
        key = (run["scenario"], run["trial_id"])
        pair = pairs.setdefault(key, {})
        if variant in pair:
            raise ValueError("Duplicate scenario/trial/variant")
        pair[variant] = run
        config_hashes[variant].add(run["planner_params_sha256"])
        if not finite(run["elapsed_ros_s"]) or run["elapsed_ros_s"] < 0:
            raise ValueError("Invalid measured elapsed time")
    if any(len(hashes) != 1 for hashes in config_hashes.values()):
        raise ValueError("Each variant must use one fixed parameter snapshot")

    common_fields = ("environment", "hardware", "world_id", "route_sha256", "map_yaml_sha256",
                     "map_image_sha256", "active_map_sha256", "expected_goals", "policy")
    successful_pairs = []
    for key, pair in pairs.items():
        if set(pair) != {"baseline", "tuned"}:
            raise ValueError("Unpaired trial: " + str(key))
        baseline, tuned = pair["baseline"], pair["tuned"]
        for field in common_fields:
            if baseline.get(field) is None or baseline[field] != tuned.get(field):
                raise ValueError("Paired context differs or is missing: " + field)
        a, b = baseline["start_pose"], tuned["start_pose"]
        if not all(finite(p[k]) for p in (a, b) for k in ("x", "y", "yaw")):
            raise ValueError("Missing measured start pose")
        if math.hypot(a["x"] - b["x"], a["y"] - b["y"]) > .05 or angle_error(a["yaw"], b["yaw"]) > .1:
            raise ValueError("Paired start poses differ by more than 0.05 m or 0.1 rad")
        if trial_passes(baseline) and trial_passes(tuned):
            successful_pairs.append((baseline, tuned))

    output = {"schema_version": 1, "evidence_type": "paired_ros_navigation_trials", "paired_trials": len(pairs),
              "success_definition": "all planned action goals SUCCEEDED and satisfy fixed localization tolerances",
              "collision_free_success_rate": None, "variants": {}}
    for variant in ("baseline", "tuned"):
        trials = [p[variant] for p in pairs.values()]
        successes = sum(trial_passes(r) for r in trials)
        output["variants"][variant] = {"attempted_trials": len(trials), "successful_trials": successes,
                                       "patrol_success_rate": successes / len(trials)}
    output["success_rate_delta_percentage_points"] = 100 * (
        output["variants"]["tuned"]["patrol_success_rate"] - output["variants"]["baseline"]["patrol_success_rate"])
    times = [b["elapsed_ros_s"] - a["elapsed_ros_s"] for a, b in successful_pairs]
    paths = [measured_path(b) - measured_path(a) for a, b in successful_pairs
             if measured_path(a) is not None and measured_path(b) is not None]
    output["both_successful_pairs"] = len(successful_pairs)
    output["mean_paired_time_delta_s_tuned_minus_baseline"] = statistics.mean(times) if times else None
    output["valid_path_pairs"] = len(paths)
    output["mean_paired_path_delta_m_tuned_minus_baseline"] = statistics.mean(paths) if paths else None
    output["limitations"] = ["Failures and interrupted attempts remain in the success-rate denominator.",
                             "Time/path deltas use only pairs in which both variants succeeded.",
                             "Pose errors use map localization, not external ground truth.",
                             "Collision contacts are not instrumented; no collision-free claim is made."]
    return output
