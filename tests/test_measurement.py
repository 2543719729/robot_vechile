"""Synthetic unit fixtures verify statistics; they are never project results."""
import copy
import sys
import threading
import unittest
from pathlib import Path
from types import SimpleNamespace as Obj

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "scripts"))
from patrol_metrics import compare_trials, goal_passes, trial_passes, measured_path
from run_patrol import OdomDistance, wall_call


def fixture(variant="baseline", trial="1"):
    return {"schema_version": 1, "evidence_type": "ros_navigation_trial", "run_id": variant + trial,
            "variant": variant, "scenario": "synthetic_unit_test", "trial_id": trial,
            "planner_params_sha256": variant, "environment": "simulation", "hardware": "unit_test",
            "world_id": "test", "route_sha256": "r", "map_yaml_sha256": "m", "map_image_sha256": "i",
            "active_map_sha256": "a", "expected_goals": 1, "completed": True,
            "start_pose": {"x": 0, "y": 0, "yaw": 0}, "elapsed_ros_s": 10,
            "policy": {"xy_tolerance_m": .1, "yaw_tolerance_rad": .2,
                       "goal_timeout_ros_s": 60, "goal_timeout_wall_s": 120},
            "goals": [{"action_status": 3, "timeout": False, "xy_error_m": .02,
                       "yaw_error_rad": .03, "path_length_odom_m": 2,
                       "elapsed_ros_s": 10, "elapsed_wall_s": 5}]}


class OutcomeTests(unittest.TestCase):
    def test_succeeded_action_without_pose_is_not_qualified_success(self):
        run = fixture()
        run["goals"][0]["xy_error_m"] = None
        self.assertFalse(trial_passes(run))

    def test_failure_and_interruption_stay_in_denominator(self):
        runs = [fixture(v, t) for v in ("baseline", "tuned") for t in ("1", "2")]
        runs[1]["completed"] = False
        runs[3]["goals"][0]["action_status"] = 4
        report = compare_trials(runs)
        self.assertEqual(report["variants"]["baseline"]["patrol_success_rate"], .5)
        self.assertEqual(report["variants"]["tuned"]["patrol_success_rate"], .5)
        self.assertEqual(report["both_successful_pairs"], 1)
        self.assertIsNone(report["collision_free_success_rate"])

    def test_timeout_or_late_success_fails(self):
        run = fixture()
        run["goals"][0]["elapsed_ros_s"] = 61
        self.assertFalse(trial_passes(run))
        run["goals"][0]["elapsed_ros_s"] = 10
        run["goals"][0]["timeout"] = True
        self.assertFalse(trial_passes(run))

    def test_unpaired_trials_rejected(self):
        with self.assertRaises(ValueError):
            compare_trials([fixture()])

    def test_different_route_map_policy_or_start_rejected(self):
        for field in ("route_sha256", "active_map_sha256", "map_image_sha256", "hardware", "world_id"):
            a, b = fixture(), fixture("tuned")
            b[field] = "different"
            with self.subTest(field=field), self.assertRaises(ValueError):
                compare_trials([a, b])
        a, b = fixture(), fixture("tuned")
        b["start_pose"]["x"] = .06
        with self.assertRaises(ValueError):
            compare_trials([a, b])

    def test_duplicate_trial_rejected(self):
        a, b = fixture(), fixture("tuned")
        with self.assertRaises(ValueError):
            compare_trials([a, b, copy.deepcopy(b)])

    def test_nan_cannot_pass(self):
        run = fixture()
        run["goals"][0]["xy_error_m"] = float("nan")
        self.assertFalse(trial_passes(run))

    def test_missing_odometry_is_unknown_not_zero_length(self):
        run = fixture()
        run["goals"][0]["path_length_odom_m"] = None
        self.assertIsNone(measured_path(run))

    def test_empty_measurements_rejected(self):
        with self.assertRaises(ValueError):
            compare_trials([])


def odometry(t, x, y=0, frame="odom"):
    return Obj(header=Obj(stamp=Obj(to_sec=lambda: t), frame_id=frame),
               pose=Obj(pose=Obj(position=Obj(x=x, y=y))))


class CaptureTests(unittest.TestCase):
    def test_distance_and_reset(self):
        distance = OdomDistance()
        self.assertIsNone(distance.value())
        distance.callback(odometry(0, 0))
        distance.callback(odometry(.1, .1))
        self.assertAlmostEqual(distance.value(), .1)
        distance.reset()
        self.assertIsNone(distance.value())

    def test_gaps_clock_reset_frame_change_invalidate_path(self):
        for sample in (odometry(1, .1), odometry(-1, .1), odometry(.1, .1, frame="map"), odometry(.1, 2)):
            distance = OdomDistance()
            distance.callback(odometry(0, 0))
            distance.callback(sample)
            self.assertIsNone(distance.value())

    def test_frozen_ros_wait_has_wall_bound(self):
        event = threading.Event()
        try:
            with self.assertRaises(TimeoutError):
                wall_call(lambda: event.wait(), .02)
        finally:
            event.set()


if __name__ == "__main__":
    unittest.main()
