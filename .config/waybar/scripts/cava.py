#!/usr/bin/env python3
import os
import subprocess
import sys
import time

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
CONF_PATH = os.path.join(SCRIPT_DIR, "cava.conf")
BAR_CHARS = [" ", " ", "▂", "▃", "▄", "▅", "▆", "▇", "█"]

def main():
    if not os.path.exists(CONF_PATH):
        sys.exit(1)

    cmd = ["cava", "-p", CONF_PATH]
    proc = subprocess.Popen(
        cmd,
        stdout=subprocess.PIPE,
        stderr=subprocess.DEVNULL,
        text=True,
        bufsize=1
    )

    silent_count = 0
    max_silent_frames = 30  # ~1 second at 30fps

    try:
        for line in iter(proc.stdout.readline, ''):
            parts = line.strip().split(";")
            vals = [int(v) for v in parts if v.isdigit()]
            if not vals:
                continue

            if all(v == 0 for v in vals):
                silent_count += 1
                if silent_count > max_silent_frames:
                    print("", flush=True)
                else:
                    bars = "".join(BAR_CHARS[v] for v in vals)
                    print(bars, flush=True)
            else:
                silent_count = 0
                bars = "".join(BAR_CHARS[min(len(BAR_CHARS) - 1, v)] for v in vals)
                print(bars, flush=True)

    except KeyboardInterrupt:
        pass
    finally:
        proc.terminate()

if __name__ == "__main__":
    main()
