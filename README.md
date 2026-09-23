# Project Stone

A private gameplay prototype exploring a modern evolution of classic four-player isometric arena fighting.

## Alpha 0.1
Goal: prove that movement, combat, environmental interaction and Power Stone-style transformation are immediately fun in a shared 3D arena.

### Vertical slice
- 1–4 local players
- Shared dynamic isometric camera
- 360-degree movement
- Attack, jump, evade, grab and throw
- Pick-up/use/throw environmental objects
- Three-stone collection and temporary transformation
- Runaway Train greybox
- Sinking Pirate Ship second alpha stage
- 60 FPS minimum target

## Engine
Godot 4 prototype.

## Download the playable alpha
Open [Build Alpha in GitHub Actions](https://github.com/samgosper-commits/project-stone/actions/workflows/build-alpha.yml), select the latest successful run on **main**, and scroll to **Artifacts**. Sign in to GitHub to download:

- **Project-Stone-Alpha-Android**: extract the ZIP and install `ProjectStoneAlpha.apk` on an ARM64 Android device. This is a debug-signed development build.
- **Project-Stone-Alpha-Windows**: extract the ZIP and run `ProjectStoneAlpha.exe` on Windows.

Windows and Android build independently. Each artifact includes a SHA-256 checksum and is retained for 90 days. **Run workflow** creates fresh downloads if an older artifact has expired. The separate **Godot Validate** workflow only checks the game; it does not produce downloads.

The current greybox prototype uses keyboard or controller input; touch controls are not implemented. Player one: WASD to move, Space to jump, J to attack, K for action, L to evade, I for power. Controllers use the left stick and A/X/B/Y/right shoulder.

## Production principle
Preserve arcade immediacy and environmental chaos. Modern systems should deepen play without replacing the simple controls or readable shared camera.


<!-- alpha-ci-observability -->

<!-- ci-retry-android -->
