# Combat Foundation

## Design goal
Simple first minute, deep hundredth match.

## Core verbs
- Move: unrestricted 360-degree analogue movement
- Jump: fast arcade trajectory
- Attack: contextual fast strike/string
- Heavy: stronger knockback and environmental utility
- Grab: opponents and interactable objects
- Throw: directional, readable and interruptible
- Evade: short commitment movement option
- Item use: contextual by item type

## Targeting
No conventional hard lock-on. Use subtle contextual facing/attack assistance based on stick direction, proximity and threat relevance. Player movement remains free.

## Combat state model
Neutral -> locomotion -> attack startup -> active -> recovery
Neutral/locomotion -> jump -> aerial -> landing
Neutral/locomotion -> grab -> carry/hold -> throw/use
Vulnerable -> hitstun/knockback -> recovery
Eligible -> transformation -> powered state -> expiry

## Principles
- Short input vocabulary
- Strong hit reactions
- Environmental improvisation is as important as combos
- Knockback creates positioning opportunities rather than long helpless states
- Avoid systems that force players to stare at meters
