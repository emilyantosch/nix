#!/usr/bin/env python3
"""Claude Code status line: folder, git branch, context usage, 5h/7d rate limits."""
import json
import os
import subprocess
import sys

data = json.load(sys.stdin)

RESET = "\033[0m"
DIM = "\033[2m"
BLUE = "\033[34m"
MAGENTA = "\033[35m"
GREEN = "\033[32m"
YELLOW = "\033[33m"
RED = "\033[31m"


def color_for(pct):
    if pct >= 80:
        return RED
    if pct >= 50:
        return YELLOW
    return GREEN


def fmt_pct(label, pct):
    if pct is None:
        return f"{DIM}{label} --{RESET}"
    pct = float(pct)
    return f"{DIM}{label}{RESET} {color_for(pct)}{pct:.0f}%{RESET}"


cwd = (data.get("workspace") or {}).get("current_dir") or data.get("cwd") or os.getcwd()
home = os.path.expanduser("~")
folder = os.path.basename(cwd.rstrip("/")) or cwd
if cwd == home:
    folder = "~"

parts = [f"{BLUE}{folder}{RESET}"]

try:
    branch = subprocess.run(
        ["git", "-C", cwd, "--no-optional-locks", "branch", "--show-current"],
        capture_output=True, text=True, timeout=1,
    ).stdout.strip()
    if branch:
        parts.append(f"{MAGENTA} {branch}{RESET}")
except Exception:
    pass

ctx = data.get("context_window") or {}
parts.append(fmt_pct("ctx", ctx.get("used_percentage")))

limits = data.get("rate_limits") or {}
parts.append(fmt_pct("5h", (limits.get("five_hour") or {}).get("used_percentage")))
parts.append(fmt_pct("7d", (limits.get("seven_day") or {}).get("used_percentage")))

print(f" {DIM}│{RESET} ".join(parts))
