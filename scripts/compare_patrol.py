#!/usr/bin/env python3
"""Compare actual, paired patrol records; reject missing or mismatched trials."""
import argparse
import json
from pathlib import Path
from patrol_metrics import compare_trials


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("records", nargs="+")
    parser.add_argument("--output", required=True)
    args = parser.parse_args()
    try:
        runs = [json.loads(Path(p).read_text()) for p in args.records]
        output = compare_trials(runs)
    except (ValueError, KeyError, TypeError) as error:
        parser.error(str(error))
    path = Path(args.output)
    if path.exists():
        parser.error("Output already exists; select a new report filename")
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(output, ensure_ascii=False, indent=2, allow_nan=False) + "\n")
    print(json.dumps(output, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
