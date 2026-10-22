#!/usr/bin/env python3
"""Summarize measured ROS navigation trials from a CSV file.

This tool computes metrics from the supplied rows; it does not collect robot data
or verify that the input measurements are truthful. Keep the raw logs/bags and
record the exact code/configuration used for each trial.
"""

import argparse
import csv
import json
import math
import statistics
from collections import defaultdict
from pathlib import Path
from typing import Dict, List, Optional, Tuple

REQUIRED_COLUMNS = (
    "run_id",
    "scene_id",
    "seed",
    "config",
    "goal_count",
    "reached_count",
    "duration_s",
    "path_length_m",
    "collision_count",
    "recovery_count",
    "min_clearance_m",
)


def _integer(value: str, field: str, line: int) -> int:
    try:
        parsed = int(value)
    except (TypeError, ValueError) as exc:
        raise ValueError(f"line {line}: {field} must be an integer") from exc
    return parsed


def _number(value: str, field: str, line: int, optional: bool = False) -> Optional[float]:
    if optional and (value is None or value.strip() == ""):
        return None
    try:
        parsed = float(value)
    except (TypeError, ValueError) as exc:
        raise ValueError(f"line {line}: {field} must be a number") from exc
    if not math.isfinite(parsed):
        raise ValueError(f"line {line}: {field} must be finite")
    if parsed < 0:
        raise ValueError(f"line {line}: {field} must be >= 0")
    return parsed


def load_runs(csv_path: str) -> List[dict]:
    """Load and validate a navigation-trial CSV."""
    path = Path(csv_path)
    with path.open("r", encoding="utf-8-sig", newline="") as stream:
        reader = csv.DictReader(stream)
        if reader.fieldnames is None:
            raise ValueError("CSV is empty or has no header")
        missing = [name for name in REQUIRED_COLUMNS if name not in reader.fieldnames]
        if missing:
            raise ValueError("missing required columns: " + ", ".join(missing))

        runs: List[dict] = []
        seen_ids = set()
        seen_pairs = set()
        for line, raw in enumerate(reader, start=2):
            if not raw or all(value is None or value.strip() == "" for value in raw.values()):
                continue
            run_id = (raw.get("run_id") or "").strip()
            scene_id = (raw.get("scene_id") or "").strip()
            config = (raw.get("config") or "").strip().lower()
            if not run_id or not scene_id:
                raise ValueError(f"line {line}: run_id and scene_id must not be empty")
            if run_id in seen_ids:
                raise ValueError(f"line {line}: duplicate run_id {run_id!r}")
            if config not in ("baseline", "tuned"):
                raise ValueError(f"line {line}: config must be 'baseline' or 'tuned'")

            seed = _integer(raw.get("seed", ""), "seed", line)
            goal_count = _integer(raw.get("goal_count", ""), "goal_count", line)
            reached_count = _integer(raw.get("reached_count", ""), "reached_count", line)
            collision_count = _integer(raw.get("collision_count", ""), "collision_count", line)
            recovery_count = _integer(raw.get("recovery_count", ""), "recovery_count", line)
            if seed < 0:
                raise ValueError(f"line {line}: seed must be >= 0")
            if goal_count <= 0:
                raise ValueError(f"line {line}: goal_count must be > 0")
            if not 0 <= reached_count <= goal_count:
                raise ValueError(f"line {line}: reached_count must be between 0 and goal_count")
            if collision_count < 0 or recovery_count < 0:
                raise ValueError(f"line {line}: collision_count and recovery_count must be >= 0")

            run = {
                "run_id": run_id,
                "scene_id": scene_id,
                "seed": seed,
                "config": config,
                "goal_count": goal_count,
                "reached_count": reached_count,
                "duration_s": _number(raw.get("duration_s", ""), "duration_s", line),
                "path_length_m": _number(raw.get("path_length_m", ""), "path_length_m", line),
                "collision_count": collision_count,
                "recovery_count": recovery_count,
                "min_clearance_m": _number(raw.get("min_clearance_m", ""), "min_clearance_m", line, optional=True),
            }
            pair_key = (scene_id, seed, config)
            if pair_key in seen_pairs:
                raise ValueError(
                    f"line {line}: duplicate scene_id/seed/config {scene_id!r}/{seed}/{config}; "
                    "use a distinct seed for each repeat"
                )
            seen_ids.add(run_id)
            seen_pairs.add(pair_key)
            runs.append(run)

    if not runs:
        raise ValueError("CSV contains no trial rows")
    return runs


def _mean(values: List[float]) -> Optional[float]:
    return round(statistics.mean(values), 6) if values else None


def _successful(run: dict) -> bool:
    return run["reached_count"] == run["goal_count"] and run["collision_count"] == 0


def summarize(runs: List[dict]) -> dict:
    """Return per-configuration metrics and matched baseline/tuned comparisons."""
    by_config = {}
    for config in ("baseline", "tuned"):
        subset = [run for run in runs if run["config"] == config]
        if not subset:
            continue
        successful = [run for run in subset if _successful(run)]
        total_goals = sum(run["goal_count"] for run in subset)
        total_reached = sum(run["reached_count"] for run in subset)
        clearances = [run["min_clearance_m"] for run in subset if run["min_clearance_m"] is not None]
        by_config[config] = {
            "runs": len(subset),
            "successful_missions": len(successful),
            "mission_success_rate_pct": round(100.0 * len(successful) / len(subset), 3),
            "waypoint_success_rate_pct": round(100.0 * total_reached / total_goals, 3),
            "mean_duration_success_s": _mean([run["duration_s"] for run in successful]),
            "mean_path_length_success_m": _mean([run["path_length_m"] for run in successful]),
            "total_collisions": sum(run["collision_count"] for run in subset),
            "mean_recoveries_per_mission": _mean([float(run["recovery_count"]) for run in subset]),
            "mean_min_clearance_m": _mean(clearances),
        }

    index: Dict[Tuple[str, int], Dict[str, dict]] = defaultdict(dict)
    for run in runs:
        index[(run["scene_id"], run["seed"])][run["config"]] = run
    pairs = [pair for pair in index.values() if "baseline" in pair and "tuned" in pair]

    comparison = None
    if pairs:
        baseline_success = [_successful(pair["baseline"]) for pair in pairs]
        tuned_success = [_successful(pair["tuned"]) for pair in pairs]
        both_successful = [
            pair for pair in pairs
            if _successful(pair["baseline"]) and _successful(pair["tuned"])
        ]
        baseline_rate = 100.0 * sum(baseline_success) / len(pairs)
        tuned_rate = 100.0 * sum(tuned_success) / len(pairs)
        comparison = {
            "paired_trials": len(pairs),
            "baseline_success_rate_pct": round(baseline_rate, 3),
            "tuned_success_rate_pct": round(tuned_rate, 3),
            "success_rate_delta_percentage_points": round(tuned_rate - baseline_rate, 3),
            "duration_pairs_both_successful": len(both_successful),
            "mean_duration_delta_tuned_minus_baseline_s": _mean([
                pair["tuned"]["duration_s"] - pair["baseline"]["duration_s"]
                for pair in both_successful
            ]),
            "mean_path_length_delta_tuned_minus_baseline_m": _mean([
                pair["tuned"]["path_length_m"] - pair["baseline"]["path_length_m"]
                for pair in both_successful
            ]),
            "mean_collision_count_delta_tuned_minus_baseline": _mean([
                float(pair["tuned"]["collision_count"] - pair["baseline"]["collision_count"])
                for pair in pairs
            ]),
            "mean_recovery_count_delta_tuned_minus_baseline": _mean([
                float(pair["tuned"]["recovery_count"] - pair["baseline"]["recovery_count"])
                for pair in pairs
            ]),
        }

    return {
        "trial_count": len(runs),
        "success_definition": "all goals reached and zero recorded collisions",
        "by_config": by_config,
        "paired_comparison": comparison,
        "warning": "Metrics summarize the supplied CSV only; verify it against raw logs/bags.",
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("csv_path", help="CSV with measured baseline/tuned navigation trials")
    args = parser.parse_args()
    try:
        report = summarize(load_runs(args.csv_path))
    except (OSError, ValueError) as exc:
        parser.error(str(exc))
    print(json.dumps(report, indent=2, ensure_ascii=False))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
