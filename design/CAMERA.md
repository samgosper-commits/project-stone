# Shared Arena Camera

## Objective
Preserve the readable elevated three-quarter view of classic isometric arena fighters while using perspective and smooth modern framing.

## Initial tuning targets
- Perspective camera
- Downward pitch: prototype between 35 and 45 degrees
- Tracks weighted centre of active players
- Smooth zoom based on player spread
- Arena bounds prevent excessive separation
- No split screen
- No player-controlled camera during normal combat
- Stage events may temporarily bias framing but never obscure active fighters

## Rules
1. Readability beats spectacle.
2. Camera motion should not make players correct their movement unexpectedly.
3. Zoom changes are damped and predictable.
4. Four-player worst-case separation is the tuning case.
5. Important hazards must enter frame before becoming dangerous.
