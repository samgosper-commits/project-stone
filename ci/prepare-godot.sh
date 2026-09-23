#!/usr/bin/env bash
set -euo pipefail

platform="${1:?Specify Windows or Android}"
templates_dir="${XDG_DATA_HOME:-$HOME/.local/share}/godot/export_templates/4.4.stable"
mkdir -p "$templates_dir"
cp -r /root/.local/share/godot/export_templates/4.4.stable/. "$templates_dir/"

if [[ "$platform" == Android ]]; then
  java_bin="$(readlink -f "$(command -v java)")"
  java_sdk="$(dirname "$(dirname "$java_bin")")"
  android_sdk="/opt/android-sdk"
  test -x "$java_sdk/bin/java"
  test -x "$java_sdk/bin/jarsigner"
  test -x "$android_sdk/platform-tools/adb"
  test -s "$templates_dir/android_debug.apk"
  keytool -genkeypair -noprompt -keyalg RSA -alias androiddebugkey \
    -keypass android -keystore "$HOME/debug.keystore" -storepass android \
    -dname "CN=Android Debug,O=Project Stone,C=AU" -validity 10000

  settings_dir="${XDG_CONFIG_HOME:-$HOME/.config}/godot"
  mkdir -p "$settings_dir"
  # EditorSettings is a Godot resource: both headers below are required.
  # Keep this heredoc outside workflow YAML so its indentation cannot break CI.
  cat > "$settings_dir/editor_settings-4.4.tres" <<EOF
[gd_resource type="EditorSettings" format=3]

[resource]
export/android/java_sdk_path = "$java_sdk"
export/android/android_sdk_path = "$android_sdk"
export/android/debug_keystore = "$HOME/debug.keystore"
export/android/debug_keystore_user = "androiddebugkey"
export/android/debug_keystore_pass = "android"
EOF
fi
