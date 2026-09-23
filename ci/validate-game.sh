#!/usr/bin/env bash
set -euo pipefail
mkdir -p build/logs
godot --headless --path game --editor --import 2>&1 | tee build/logs/import.log
godot --headless --path game --quit-after 120 2>&1 | tee build/logs/smoke.log
godot --headless --path game --script ../ci/render-check.gd 2>&1 | tee build/logs/scene-check.log
timeout 45 godot --headless --path game --script ../ci/gameplay-check.gd 2>&1 | tee build/logs/gameplay-check.log
# Godot can report script failures while returning exit code zero.
if grep -E 'SCRIPT ERROR:|Parse Error:|Failed to load script|Could not load editor settings' build/logs/import.log build/logs/smoke.log build/logs/scene-check.log build/logs/gameplay-check.log; then
  echo 'Game validation failed; see the errors above.' >&2
  exit 1
fi
