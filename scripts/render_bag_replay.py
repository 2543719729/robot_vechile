#!/usr/bin/env python3
"""Render measured /odom as a video and a static figure, without invented motion."""
import argparse
from pathlib import Path

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from matplotlib.animation import FFMpegWriter
from rosbags.highlevel import AnyReader

from audit_bags import read_odometry


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--bag", default="src/bobac3_slam/bobac3_gazebo_macth.bag")
    parser.add_argument("--output", default="docs/media/historical_odometry.mp4")
    parser.add_argument("--figure", default="docs/media/historical_odometry.png")
    parser.add_argument("--speedup", type=float, default=4)
    parser.add_argument("--fps", type=int, default=12)
    args = parser.parse_args()
    if args.speedup <= 0 or args.fps <= 0:
        parser.error("speedup and fps must be positive")
    with AnyReader([Path(args.bag)]) as reader:
        rows = read_odometry(reader)
    if len(rows) < 2:
        raise SystemExit("At least two /odom samples are required")
    t = [(r[0] - rows[0][0]) / 1e9 for r in rows]
    x, y, speed = [[r[i] for r in rows] for i in (1, 2, 4)]
    plt.rcParams.update({"font.family": "DejaVu Sans", "axes.spines.top": False,
                         "axes.spines.right": False, "font.size": 10})
    fig, (path_ax, speed_ax) = plt.subplots(1, 2, figsize=(10, 5), width_ratios=(1.1, 1))
    fig.patch.set_facecolor("#f4f7fb")
    fig.suptitle("Historical ROS bag: recorded odometry replay", weight="bold", fontsize=14)
    fig.text(.5, .025, "No goal/result labels | odometry estimate, not ground truth | playback %gx" % args.speedup,
             ha="center", fontsize=8, color="#475569")
    path_ax.set(xlabel="odom x (m)", ylabel="odom y (m)", title="Measured planar trajectory",
                xlim=(min(x) - .25, max(x) + .25), ylim=(min(y) - .25, max(y) + .25))
    path_ax.set_aspect("equal")
    path_ax.grid(alpha=.2)
    path_ax.plot(x[0], y[0], "o", color="#10b981", label="start")
    trail, = path_ax.plot([], [], color="#2563eb", linewidth=2, label="/odom")
    point, = path_ax.plot([], [], "o", color="#ef4444", markersize=7)
    path_ax.legend(loc="upper left", frameon=False)
    speed_ax.plot(t, speed, color="#cbd5e1", linewidth=1)
    trace, = speed_ax.plot([], [], color="#0f766e", linewidth=1.5)
    speed_ax.set(xlabel="recorded time (s)", ylabel="reported planar speed (m/s)",
                 title="Recorded twist magnitude", xlim=(0, t[-1]), ylim=(0, max(speed) * 1.15 + .01))
    speed_ax.grid(alpha=.2)
    timestamp = speed_ax.text(.05, .92, "", transform=speed_ax.transAxes)
    fig.tight_layout(rect=(0, .06, 1, .92))

    def update(index):
        trail.set_data(x[:index + 1], y[:index + 1])
        point.set_data([x[index]], [y[index]])
        trace.set_data(t[:index + 1], speed[:index + 1])
        timestamp.set_text("recorded t = %.2f s" % t[index])

    output = Path(args.output)
    output.parent.mkdir(parents=True, exist_ok=True)
    writer = FFMpegWriter(fps=args.fps, codec="libx264", extra_args=["-pix_fmt", "yuv420p", "-movflags", "+faststart"])
    index = 0
    with writer.saving(fig, str(output), dpi=100):
        for frame in range(int(t[-1] / args.speedup * args.fps) + 1):
            sample_time = frame * args.speedup / args.fps
            while index + 1 < len(t) and t[index + 1] <= sample_time:
                index += 1
            update(index)
            writer.grab_frame()
        update(len(rows) - 1)
        writer.grab_frame()
    figure = Path(args.figure)
    figure.parent.mkdir(parents=True, exist_ok=True)
    fig.savefig(figure, dpi=150, facecolor=fig.get_facecolor())
    plt.close(fig)
    print("Rendered", output, "and", figure, "from", len(rows), "recorded samples")


if __name__ == "__main__":
    main()
