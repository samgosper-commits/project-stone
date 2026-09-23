# Power Stone 2 DNA Study

Purpose: understand the behavioural design of Power Stone 2 and reproduce its *principles* in Project Stone without copying proprietary code or assets.

## Confirmed baseline

### Control economy
Power Stone 2 uses an unusually small input vocabulary for a 3D arena fighter: 360-degree movement plus Attack, Jump and Action, with a separate discard-item input and two Power Fusion inputs on Dreamcast. The important design consequence is that complexity comes from context and arena state rather than command-list execution.

**Project Stone:** preserve this economy. Do not add a conventional light/heavy fighting-game layout by default. Prototype a contextual Attack + Jump + Action core first; any additional input must justify itself in playtests.

### No conventional block
The original does not use a normal hold-to-block system. Defensive play comes from movement and a timed dodge. The original manual describes directional input timed to an incoming attack; our dedicated dodge button is a prototype choice, not the original mapping.

**Project Stone:** prototype movement/evasion as primary defence. Avoid creating stationary defensive play.

### Three stones create the match objective
Collecting three Power Stones temporarily transforms a fighter and enables powerful attacks. Repeated hits can force a stone-holder to drop a stone.

**Why it works:** stones create a moving objective layered over the fight. Players switch naturally between attacking, escaping, intercepting and scavenging.

**Project Stone:** preserve three-stone transformation and hit-driven stone turnover. Tune comeback/runaway behaviour rather than replacing the objective.

### Four-player camera
Power Stone 2 pulls the camera farther away to keep four fighters visible. Contemporary reviews praised its ability to contain the action but also identified loss of character readability when it zoomed too far out.

**Project Stone:** preserve shared framing, improve the failure case. Use dynamic zoom, stronger silhouettes/player markers, arena soft-bounds and predictive framing before resorting to extreme zoom-out.

### Dynamic stages are gameplay
Stages change during the match and can contain several sequential combat situations. Documented examples include an airship breaking apart into a freefall sequence before a final platform, submerging submarines, and a boulder chase.

**Why it works:** the arena continuously changes the optimal strategy. Traversal and survival temporarily become as important as direct combat.

**Project Stone:** every flagship stage needs at least one meaningful rules/layout change, not merely a cinematic background event.

### Environment as moveset
Original arenas allow extensive climbing, pickup/throw interactions, mounted weapons/vehicles and many item types.

**Project Stone:** treat the environment as a universal secondary moveset. Contextual Action should resolve the nearest sensible interaction with predictable priority.

### Item abundance
Power Stone 2 dramatically expands item variety; contemporary coverage describes weapons, mobility tools, healing, defensive and status items.

**Project Stone:** items should change decisions, not merely add damage. Prototype categories: melee, projectile, mobility, healing, defence, trap and arena-control.

### Readability versus chaos
Contemporary reviews repeatedly describe four-player play as exceptionally frantic, while also noting that players can lose track of their fighter.

**Project Stone 2026 opportunity:** preserve *decision chaos*, reduce *visual confusion*. Effects should be short, silhouettes strong, player IDs persistent, and camera movement predictable.

## Preserve / Refine / Expand

| System | Original DNA | Project Stone |
|---|---|---|
| Movement | Free 360-degree arena movement | PRESERVE; quantify acceleration/turning/jump arc |
| Inputs | Very small contextual control set | PRESERVE |
| Defence | Movement + timed dodge, no standard block | PRESERVE / REFINE |
| Targeting | Context-sensitive attacks | STUDY / REFINE |
| Power Stones | 3 stones = temporary transformation | PRESERVE |
| Stone turnover | Damage can cause stones to drop | PRESERVE / tune |
| Camera | Shared camera contains all fighters | PRESERVE / REFINE readability |
| Stages | Multi-phase interactive arenas | EXPAND |
| Items | Large, varied sandbox | PRESERVE / EXPAND |
| Environment | Climb/use/throw/mount interactions | EXPAND |
| Multiplayer | 4-player chaos is the centre | PRESERVE |
| Single-player | Secondary to multiplayer in original | EXPAND later |

## Measurement backlog

Do not guess these values. Measure from captured gameplay/reference footage where possible:
- base run speed relative to character height
- acceleration/deceleration
- 180-degree turn response
- jump height, airtime and horizontal authority
- dodge duration, travel distance and invulnerability window
- attack startup/active/recovery frames
- contextual attack facing cone and acquisition distance
- grab/action acquisition radius
- throw speed, arc and recovery
- hitstun and knockback curves
- knockdown/get-up duration
- stone drop trigger/rules
- transformed-state duration
- Power Fusion resource/cost behaviour
- camera pitch/FOV
- camera follow damping
- zoom response versus fighter spread
- stage transition duration
- item spawn cadence and density

## Alpha control correction

The first Project Stone controller specification included a dedicated Heavy input. This is now considered an experimental branch, not the baseline. The DNA baseline will first test:

**Move + Attack + Jump + Action + Dodge + Power**

Context determines attacks, grabs, pickups, throws, climbing and object use. We only add dedicated combat buttons if testing proves the original control economy cannot support the desired 2026 depth.

## Design test

A new mechanic passes the DNA test only if:
1. a first-time player can discover it without studying a command list;
2. it creates interaction with opponents, stones, items or the arena;
3. it does not reduce movement freedom;
4. it remains readable with four players;
5. it produces interesting decisions rather than additional execution burden.


## Reference correction, 2026-09-23

See [Gameplay reference](GAMEPLAY_REFERENCE.md#reference-review--2026-09-23) for source-backed throw, catch, dodge and Falcon movement distinctions and the explicit video playback limitation. Do not treat alpha 0.1.2 as a measured reconstruction of the original. Prioritise this correction record over earlier shorthand about input fidelity.
