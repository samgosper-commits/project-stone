# Gameplay reference and tuning

User-supplied reference: https://www.youtube.com/live/XDWq8QXk8IM

Status: the linked video could not be loaded in this session. It has NOT been watched or measured. Alpha 0.1.2 fixes confirmed code defects; it does not claim to reproduce the original game's physics. Frame-by-frame comparison remains pending.

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


## Reference review — 2026-09-23

### Video access and evidence status

| Reference | Inspection result | Usable evidence |
| --- | --- | --- |
| RQ87, Falcon Dreamcast playthrough: https://www.youtube.com/watch?v=IB9elrnhILM | Page loaded; player stayed at 0:00 with a buffering spinner, including after one reload | Title, duration 19:18 and creator description advertising 60fps; no gameplay observations |
| Red Venom Corp., co-op playthrough: https://www.youtube.com/watch?v=XsoGqkLXl7g&t=184s | Page loaded at the requested 3:04 point; gameplay remained black/buffering | Title and listed chapter; no gameplay observations |

These videos have NOT been visually analysed. Do not use their metadata or comments as evidence for acceleration, airtime, throw arcs, targeting, hitstun or animation timing. No physics constants were measured or changed during this review.

### Manual-backed corrections

Source: original Capcom Power Stone 2 Dreamcast manual, controls/actions/tips and Falcon profile (printed pages 4–5, 10–11 and 15), transcribed at https://manuals.plus/m/f1e4c139504ac82a01acd1853add5535509bde58dd7babf58fc2d772fe73bd84 . Cross-check of the throwing instructions: https://www.gamesdatabase.org/Media/SYSTEM/Sega_Dreamcast/manual/Formated/Power_Stone_2_-_2000_-_Eidos_Interactive.pdf . These are manual findings, not video observations.

- Movement supports a full circle; eight-way input is a control option, not the movement limit.
- With an item held, Attack directs a throw at an opponent; Action permits a directional throw.
- A timed Action press can catch a thrown object.
- Dodging uses directional input timed against an incoming attack.
- Walls can support a springboard attack through directional input plus Action.
- Falcon is an all-rounder with a double jump.

### Implications for the next implementation pass

Our 0.1.2 Attack and Action both launch in facing_direction. Split targeted and directional throws before claiming original-like behaviour. Tune target selection and release timing separately from projectile gravity. Add catch states and feedback. Preserve full analog direction as the intended default, with optional eight-way snapping. Mark the dedicated dodge button as a prototype accommodation; it is not a faithful original input scheme. Add a character movement profile so Falcon can double-jump without granting the same move to every fighter.

These are backlog decisions, not features shipped in 0.1.2. Catch windows, targeting rules, jump timings and throw trajectories remain unmeasured. Next successful footage review must record timestamps and separate observation from interpretation.
