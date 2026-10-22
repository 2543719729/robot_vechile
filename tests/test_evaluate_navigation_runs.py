import csv
import tempfile
import unittest
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "scripts"))
from evaluate_navigation_runs import load_runs, summarize  # noqa: E402


HEADER = [
    "run_id", "scene_id", "seed", "config", "goal_count", "reached_count",
    "duration_s", "path_length_m", "collision_count", "recovery_count", "min_clearance_m",
]


class NavigationMetricsTests(unittest.TestCase):
    def write_csv(self, rows):
        handle = tempfile.NamedTemporaryFile(mode="w", encoding="utf-8", newline="", delete=False)
        self.addCleanup(lambda: Path(handle.name).unlink(missing_ok=True))
        writer = csv.DictWriter(handle, fieldnames=HEADER)
        writer.writeheader()
        writer.writerows(rows)
        handle.close()
        return handle.name

    def test_summary_and_paired_comparison(self):
        path = self.write_csv([
            dict(run_id="b1", scene_id="hallway", seed=1, config="baseline", goal_count=2, reached_count=1,
                 duration_s=20, path_length_m=4.5, collision_count=0, recovery_count=1, min_clearance_m=0.30),
            dict(run_id="t1", scene_id="hallway", seed=1, config="tuned", goal_count=2, reached_count=2,
                 duration_s=15, path_length_m=3.5, collision_count=0, recovery_count=0, min_clearance_m=0.40),
            dict(run_id="b2", scene_id="hallway", seed=2, config="baseline", goal_count=2, reached_count=2,
                 duration_s=18, path_length_m=4.0, collision_count=0, recovery_count=0, min_clearance_m=0.35),
            dict(run_id="t2", scene_id="hallway", seed=2, config="tuned", goal_count=2, reached_count=2,
                 duration_s=16, path_length_m=3.8, collision_count=0, recovery_count=0, min_clearance_m=0.40),
        ])
        report = summarize(load_runs(path))
        self.assertEqual(report["trial_count"], 4)
        self.assertEqual(report["by_config"]["baseline"]["mission_success_rate_pct"], 50.0)
        self.assertEqual(report["by_config"]["baseline"]["waypoint_success_rate_pct"], 75.0)
        self.assertEqual(report["by_config"]["tuned"]["mission_success_rate_pct"], 100.0)
        self.assertEqual(report["paired_comparison"]["paired_trials"], 2)
        self.assertEqual(report["paired_comparison"]["success_rate_delta_percentage_points"], 50.0)
        self.assertEqual(report["paired_comparison"]["mean_duration_delta_tuned_minus_baseline_s"], -2.0)
        self.assertEqual(report["paired_comparison"]["mean_path_length_delta_tuned_minus_baseline_m"], -0.2)

    def test_rejects_duplicate_scene_seed_config(self):
        row = dict(run_id="b1", scene_id="hallway", seed=1, config="baseline", goal_count=1, reached_count=1,
                   duration_s=10, path_length_m=2, collision_count=0, recovery_count=0, min_clearance_m="")
        path = self.write_csv([row, dict(row, run_id="b2")])
        with self.assertRaisesRegex(ValueError, "duplicate scene_id/seed/config"):
            load_runs(path)

    def test_collision_prevents_mission_success(self):
        path = self.write_csv([
            dict(run_id="b1", scene_id="hallway", seed=1, config="baseline", goal_count=1, reached_count=1,
                 duration_s=10, path_length_m=2, collision_count=1, recovery_count=0, min_clearance_m=""),
        ])
        report = summarize(load_runs(path))
        self.assertEqual(report["by_config"]["baseline"]["mission_success_rate_pct"], 0.0)


if __name__ == "__main__":
    unittest.main()
