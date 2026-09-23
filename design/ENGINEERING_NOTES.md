# Engineering Notes

## Current playable loop
The prototype now supports free arena locomotion, jump, contextual attack acquisition, contextual Action, dodge, throwable rigid objects, health/knockback, Power Stone collection and temporary transformation.

## Context priority
Action currently resolves:
1. throw/use held object
2. nearest valid environment object
3. close opponent interaction

This priority will be playtested rather than assumed final.

## Combat assistance
Attack uses a proximity + facing-cone score rather than hard lock-on. This is intentionally subtle. Future tuning should compare acquisition cone/range against captured Power Stone 2 behaviour.

## Power Stone prototype
Three unique stone IDs trigger transformation. Transformation increases normal attack damage and unlocks a prototype Power action. Heavy enough hits can remove a held stone. Exact original rules remain a measurement task.

## Stage phase architecture
Runaway Train has a lightweight phase controller ready for Departure -> Countryside -> Bridge -> Tunnel -> Locomotive Finale. Geometry/event hooks are next.

## Next high-value work
- proper input devices for P2-P4
- attack/hit state machine and animation timing
- invulnerability during dodge
- item detection groups and prototype crates
- physical stone drops rather than deleting inventory
- stage hazards and train motion illusion
- HUD/player identification
- automated Godot headless validation in CI
