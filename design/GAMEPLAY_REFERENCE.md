# Gameplay reference and tuning

User-supplied reference: https://www.youtube.com/live/XDWq8QXk8IM

Status: the linked video could not be loaded in this session. It has NOT been watched or measured. Alpha 0.1.2 fixes confirmed code defects; it does not claim to reproduce the original game's physics. An uploaded short clip is needed for frame-by-frame comparison.

## Capture and compare

Use unobstructed clips with a fixed or slowly moving camera. Record clip timestamps and frame rate; account for playback speed. Compare distances in character heights to avoid pretending screen pixels are world metres.

| Action | Measurements to record | Prototype settings / behaviour |
| --- | --- | --- |
| Run, stop and reverse | Frames to full speed; stop distance; turning response | move_speed, acceleration, rotation_speed |
| Diagonal run | Same duration and travel distance as straight run | normalized input; eight-direction touch stick; analog pads |
| Jump and land | Time to apex, total airtime, height, air steering | jump_velocity, gravity, air_control |
| Pick up and throw | Pickup delay, hold pose, release frame, range and arc | HoldSocket; throw_speed; upward_throw; inherited movement |
| Crate impact | Contact position, bounce/break behaviour, hit reaction and recovery | contact monitoring; collision layers; impact_damage; hit states |
| Stage traversal | Feet on edges, transitions between surfaces, falls | floor snap; capsule and stage collision shapes |

For each change, replay the same test route and throw setup. Keep raw observations separate from the chosen design adjustments. Do not infer hidden physics constants from a single camera angle.

## Alpha 0.1.2 verification

Automated headless checks exercise floor stability, all eight touch directions, second-finger release isolation, normalized diagonal speed, facing direction, held-prop collision disabling, forward throw velocity and real rigid-body contact damaging a character. These checks prove these behaviours work in the tested setup; they do not establish fidelity to Power Stone 2 or replace Android playtesting.

Remaining work includes animation-timed pickup/release, context-sensitive interaction refinement, breakable props, stage edge and crowded collision playtests, and reference-based tuning of movement, jump, throw and knockback. The train remains an early blockout.
