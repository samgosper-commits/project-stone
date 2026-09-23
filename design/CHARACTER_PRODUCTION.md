# First playable character

Follow VISUAL_BIBLE.md: colourful, chunky, expressive HD 3D, readable from the shared arena camera. Keep broad costume shapes and distinct silhouettes. Fine detail comes after the character reads at gameplay size.

## Deliver one complete fighter first

The first deliverable is one fighter in normal and powered forms, sharing a usable skeleton where practical, with a complete basic animation set. The current coloured capsules remain gameplay stand-ins until this asset is ready. No finished character models are included in alpha 0.1.2.

1. **Character brief:** choose the fighter, personality, silhouette, primary colours, signature costume elements, fighting style and transformation theme. For an existing character, collect front, side, back and gameplay references so identity stays consistent.
2. **Concept sheet:** explore three silhouettes, choose one, then make consistent front/side/back views, facial expressions, colour keys and a normal/transformed comparison. Include a small mockup at actual arena camera size.
3. **Model:** build a rough 3D body and costume first; check proportions in the train scene before detailed modelling. Create deformation-friendly topology, UVs and simple stylised textures/materials. Keep collision geometry independent of costume details.
4. **Rig:** make a skeleton with hand attachment points and stable feet. Test shoulders, elbows, knees and the overhead carry pose before authoring the full animation set.
5. **Animate:** idle, run, jump rise/fall/land, three attack beats, pickup, carry idle/run, throw, dodge, hit reaction, knockdown/get-up and transformation. Add powered attacks after the base fighter feels good.
6. **Integrate:** drive the visual rig from the existing movement/combat states. Keep locomotion controlled by gameplay; use animation events for attack contact and prop release. The hand socket follows the rig while held; released props use the throw trajectory and physical contact rules.
7. **Playtest:** inspect four fighters together at maximum camera zoom, then test on Android. Check foot sliding, contact timing, crate/hand alignment, silhouette contrast and frame time. Only then expand the roster.

Concept images communicate a design; they are not rigged, animated game characters. Modelling, rigging and in-engine integration are separate deliverables.

## Animation acceptance

| Motion | What must read clearly |
| --- | --- |
| Run / reverse | Feet support movement; body turns quickly without a long sliding turn |
| Jump / land | Takeoff, apex and landing are distinct; feet meet the floor |
| Pickup / carry | Hands contact the crate; arms do not pass through the torso |
| Throw | Anticipation, release and follow-through align with the gameplay launch |
| Hit / knockdown | Direction of impact is legible; recovery has a clear end |
| Transformation | Normal identity remains recognizable; powered silhouette is distinct |

Record timing targets from supplied gameplay footage before polishing the animations. Design timings here are targets, not verified Power Stone 2 measurements.
