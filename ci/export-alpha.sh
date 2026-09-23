#!/usr/bin/env bash
set -euo pipefail
platform="${1:?Specify Windows or Android}"
case "$platform" in
  Windows) preset="Windows Desktop"; extension=exe ;;
  Android) preset=Android; extension=apk ;;
  *) echo "Unsupported platform: $platform" >&2; exit 1 ;;
esac
mkdir -p "build/$platform" build/logs
output="build/$platform/ProjectStoneAlpha.$extension"
godot --headless --path game --export-debug "$preset" "../$output" 2>&1 | tee "build/logs/export-$platform.log"
test -s "$output"
if grep -E 'SCRIPT ERROR:|Parse Error:|ERROR:.*export.*failed|Could not load editor settings' "build/logs/export-$platform.log"; then
  exit 1
fi
if [[ "$platform" == Android ]]; then
  unzip -t "$output"
  apksigner="$(find "${ANDROID_HOME:-/usr/lib/android-sdk}/build-tools" -name apksigner -type f | sort -V | tail -1)"
  test -n "$apksigner"
  "$apksigner" verify --verbose "$output"
fi
sha256sum "$output" > "$output.sha256"
if [[ -n "${GITHUB_STEP_SUMMARY:-}" ]]; then
  {
    echo "## $platform download"
    echo "Download **Project-Stone-Alpha-$platform** from the **Artifacts** section of this run, then extract the ZIP."
    echo "Game file: **ProjectStoneAlpha.$extension**"
    echo "Built from commit: $GITHUB_SHA"
  } >> "$GITHUB_STEP_SUMMARY"
fi
