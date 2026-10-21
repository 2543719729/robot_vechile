#!/usr/bin/env python3
"""Check repository structure; --runtime also checks the local ROS installation."""
import argparse
import json
import re
import shutil
import subprocess
import xml.etree.ElementTree as ET
from pathlib import Path

import yaml

ROOT = Path(__file__).resolve().parents[1]


def inspect(runtime=False):
    checks = []
    def record(name, ok, detail):
        checks.append({"check": name, "passed": bool(ok), "detail": detail})
    paths = subprocess.check_output(["git", "ls-files", "-z"], cwd=ROOT).decode().split("\0")[:-1]
    generated = [p for p in paths if p.startswith(("build/", "devel/", "install/", "AIUI_backup/"))
                 or ("/msc/" in p and not p.endswith("/msc/msc.cfg"))]
    record("tracked_generated_outputs", not generated, generated)
    errors, xml_count = [], 0
    for path in sorted((ROOT / "src").rglob("*")):
        if path.name == "package.xml" or path.suffix == ".launch":
            xml_count += 1
            try:
                ET.parse(path)
            except ET.ParseError as error:
                errors.append(str(path.relative_to(ROOT)) + ": " + str(error))
    record("package_and_launch_xml_syntax", not errors, {"files": xml_count, "errors": errors})
    broken_maps, map_count = [], 0
    for path in sorted((ROOT / "src").glob("*/maps/*.yaml")):
        data = yaml.safe_load(path.read_text())
        if "image" in data:
            map_count += 1
            if Path(data["image"]).is_absolute() or not (path.parent / data["image"]).is_file():
                broken_maps.append(str(path.relative_to(ROOT)))
    record("portable_map_images", not broken_maps, {"maps": map_count, "broken": broken_maps})
    entry = ROOT / "src/CMakeLists.txt"
    record("portable_catkin_entry", entry.is_file() and not entry.is_symlink(), "regular CMake file required")
    old_namespace = []
    for package in ("bobac3_audio", "nav_goal"):
        for path in (ROOT / "src" / package / "src").rglob("*"):
            if path.suffix in (".cpp", ".h") and re.search(
                r"robot_audio::|robot_audio/(?:Collect|Control|Awake|Nav|up_sync|robot_iat|robot_tts|robot_semanteme)\.h",
                path.read_text()):
                old_namespace.append(str(path.relative_to(ROOT)))
    record("generated_service_namespace", not old_namespace, old_namespace)
    yaml_errors = []
    for path in (ROOT / "src/bobac3_navigation/param/sim").glob("*.yaml"):
        try:
            yaml.safe_load(path.read_text())
        except yaml.YAMLError as error:
            yaml_errors.append(str(path.name) + ": " + str(error))
    record("active_sim_parameter_yaml_syntax", not yaml_errors, yaml_errors)
    if runtime:
        for executable in ("roscore", "roslaunch", "catkin_make", "gazebo", "rospack"):
            record("runtime_executable:" + executable, shutil.which(executable) is not None, shutil.which(executable))
        if shutil.which("rospack"):
            for package in ("bobac3_description", "move_base", "amcl", "map_server", "teb_local_planner", "navfn"):
                result = subprocess.run(["rospack", "find", package], capture_output=True, text=True)
                record("runtime_package:" + package, result.returncode == 0, result.stdout.strip() or result.stderr.strip())
    return {"schema_version": 1, "scope": "runtime_preflight" if runtime else "repository_static_checks",
            "passed": all(c["passed"] for c in checks), "checks": checks,
            "known_limits": ["Does not build C++ or run Gazebo/navigation.",
                             "Third-party license gaps are documented in THIRD_PARTY_NOTICES.md."]}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--runtime", action="store_true")
    parser.add_argument("--output")
    args = parser.parse_args()
    report = inspect(args.runtime)
    text = json.dumps(report, ensure_ascii=False, indent=2) + "\n"
    if args.output:
        path = Path(args.output)
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(text)
    print(text, end="")
    return 0 if report["passed"] else 1


if __name__ == "__main__":
    raise SystemExit(main())
