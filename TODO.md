# Mycelium Network — Daily Task Breakdown

**Estimated total: 40 days (~8 weeks at evenings/weekends)**
Each task is scoped for a single focused session (2–4 hours).
Check them off as you go.

---

## Phase 1 — Skeleton (Days 1–10)

> Goal: grow hyphae through soil, spend Sugar, see curves animate.

### Week 1 — Project & Map

- [ ] **Day 1 — Project scaffold**
  Create Godot 4.x project. Set up the scene tree from the GDD (Main → Map, Network, Trees, Competitors, Camera, HUD, AudioManager). Configure the Camera2D with zoom limits and edge-pan or middle-click drag. Export to HTML5 once to confirm the pipeline works.
  *Done when: you can pan and zoom over an empty scene in-browser.*

- [ ] **Day 2 — TileMap with soil layers**
  Create a TileMap with three tile types (Topsoil, Clay, Rock). Fill it procedurally in `_ready()` based on depth bands — top 30%, middle 40%, bottom 30%. Use distinct brown/grey/slate colours from the GDD palette.
  *Done when: you see three horizontal colour bands filling the screen.*

- [ ] **Day 3 — Config autoload + Mother Fungus**
  Create `Config.gd` as an autoload singleton. Paste in every tuning constant from GDD Section 17. Place the Mother Fungus as a visible node (a simple circle) in upper-center Topsoil. Implement click detection — print the clicked tile coordinate to console.
  *Done when: clicking anywhere prints a tile coordinate, and the Mother Fungus is visible.*

- [ ] **Day 4 — First straight-line hypha segment**
  On left-click near the Mother Fungus (or any existing tip), create a Line2D from the tip to the clicked tile. Track segments in an array of dictionaries `{from, to, cost, alive}`. Deduct Sugar (just a variable for now, no HUD yet). Prevent growth if Sugar is insufficient.
  *Done when: you can click to chain 10+ segments outward and growth stops when Sugar runs out.*

- [ ] **Day 5 — Bézier curves + growth animation**
  Replace straight segments with the Bézier curve sampling (random perpendicular wobble on control points, 8 subdivisions). Store wobble seeds per segment so they're stable. Add the `grow_progress` animation with ease-out and tapered tip width.
  *Done when: each new segment visually grows outward as a smooth organic curve over ~0.3 seconds.*

### Week 2 — Growth Mechanics

- [ ] **Day 6 — Layer-aware growth costs**
  Growth cost now reads from `Config.gd` based on the destination tile's layer (2/4/6 Sugar). Show cost difference by tinting the ghost position red if unaffordable. Add a temporary debug label showing current Sugar.
  *Done when: growing into Clay visibly costs more than Topsoil, and Rock costs even more.*

- [ ] **Day 7 — Forking**
  If a tip already has one outgoing segment, a second click near it creates a fork (two branches from one node). Fork costs 1.5× the base tile cost. Track tip state so you know which nodes are forkable.
  *Done when: you can split a tip into two branches and see the extra cost deducted.*

- [ ] **Day 8 — Pruning**
  Right-click on any segment severs it and all downstream segments. Recover 30% of the Sugar spent on severed segments. Visually remove the Line2D nodes. Update the segment array.
  *Done when: right-clicking a mid-network segment removes everything downstream and gives Sugar back.*

- [ ] **Day 9 — Cosmetic side-branches**
  After a trunk segment finishes growing, randomly spawn 0–2 tiny side filaments along it. These are thin, short, high-wobble Line2Ds that animate in over 0.2s. They are non-interactive and cost nothing. Store them as children of the parent segment.
  *Done when: the network looks hairy and organic without any player input.*

- [ ] **Day 10 — Basic HUD**
  Add a CanvasLayer with three resource counters (Sugar green, Water blue, Minerals amber) in the top-left. Show the Mother Fungus starting values. Update in real time as Sugar is spent. Add a contextual tooltip at bottom-center showing cost of the hovered action.
  *Done when: you can watch Sugar tick down as you grow, and see "Grow: 4 Sugar" when hovering in Clay.*

---

## Phase 2 — Core Resource Loop (Days 11–20)

> Goal: full grow → connect → exchange → maintain → prune loop working.

### Week 3 — Nodes & Trees

- [ ] **Day 11 — Water and Mineral node placement**
  Scatter Water Pocket and Mineral Vein nodes on the map using per-layer probability tables. Draw them as simple coloured circles with a sine-wave pulse animation. Store node data in the map's tile array.
  *Done when: the map has visible cyan and amber pulsing dots at appropriate depths.*

- [ ] **Day 12 — Water absorption + maintenance drain**
  Water Pockets within 3 tiles of any living hypha passively add Water per second. Every living segment drains 0.02 Water/sec. Display Water on HUD updating in real time.
  *Done when: Water rises when near water nodes and falls as the network grows larger.*

- [ ] **Day 13 — Mineral absorption + tree placement**
  Mineral Veins touched by hyphae yield Minerals per second. Place 3–5 trees at the surface with root tiles extending downward (Birch shallow, Pine medium, Oak deep). Draw trees as simple procedural trunk + circle canopy above the soil line.
  *Done when: Minerals tick up from veins, and trees are visible with root tiles in the soil.*

- [ ] **Day 14 — Root connection mechanic**
  Left-clicking on a tree's root tile (when a hypha is adjacent) establishes a connection. Costs Sugar per the GDD table. Connected root gets a visual indicator (glow ring or colour change). Track which trees are connected.
  *Done when: you can grow to a Birch root, click it, pay Sugar, and see a connected state.*

- [ ] **Day 15 — Sugar income from trees**
  Connected trees consume Minerals at their type's rate and produce Sugar proportionally. If Minerals are insufficient, Sugar production drops proportionally. Sugar now flows in from trees and out from growth — the core loop closes.
  *Done when: connecting to a tree with Minerals available visibly increases your Sugar over time.*

### Week 4 — Remaining Nodes & Network Health

- [ ] **Day 16 — Decomposing Matter nodes**
  Add Decomposing Matter nodes (brown pulse). When a hypha reaches one, it gives a one-time Sugar burst (15–25) and the node disappears. Scatter them at medium frequency across all layers.
  *Done when: reaching a brown node gives a satisfying Sugar spike and the node vanishes.*

- [ ] **Day 17 — Toxic Pocket nodes**
  Add Toxic Pockets (red pulse). Hyphae within 2 tiles take damage — segments lose health over 5 seconds and die if not pruned away. Give the player a visual warning (red tint on threatened segments).
  *Done when: growing near a toxic node visibly damages segments, and pruning saves the rest.*

- [ ] **Day 18 — Resource dot animation**
  Spawn small coloured circles (green/blue/amber) that travel along hypha Line2D points toward or away from the Mother Fungus. This is purely cosmetic — dot speed is constant, decoupled from actual resource math. Skip segments that are still growing.
  *Done when: you see coloured dots flowing through the network. It looks alive.*

- [ ] **Day 19 — Network death at zero Water**
  When global Water hits zero, outer segments begin dying inward (1 every 2 seconds). Dead segments fade out and are removed from the array. Connected trees may become disconnected. Chain reactions are possible.
  *Done when: letting Water run out causes the network to visibly wither from the edges.*

- [ ] **Day 20 — Core loop playtest**
  No new features. Play the game repeatedly. Tune values in `Config.gd`: growth costs, income rates, Water drain. Check: Is Birch too easy to reach? Is Oak reachable at all? Does Water run out too fast or too slow? Write down what feels wrong.
  *Done when: you can play for 5+ minutes with a satisfying grow/connect/manage rhythm.*

---

## Phase 3 — Seasons & Win/Lose (Days 21–25)

> Goal: a full Spring-to-Winter run with a clear outcome.

### Week 5 — Seasons

- [ ] **Day 21 — Season timer + multiplier system**
  Add a season enum and elapsed timer to the Main scene. When a season ends, advance to the next. Apply the GDD's multiplier table to all resource rates (growth cost, Sugar/Water/Mineral income). Store multipliers in `Config.gd`.
  *Done when: resource rates visibly change every few minutes as seasons progress.*

- [ ] **Day 22 — Season transition + HUD update**
  Show the season name and a progress bar at top-center of the HUD. On transition, display a 3-second overlay with the new season name in large text. Shift the background ColorRect tint per season (warm green → bright → orange → blue-grey).
  *Done when: season changes are visually obvious and the HUD tracks progress.*

- [ ] **Day 23 — Forest Health + win condition**
  Calculate Forest Health as the weighted average of all tree health values (Oak 3×, Pine 2×, Birch 1×). Display it top-right with colour coding. When Winter ends, check if Forest Health ≥ 60%. If yes, show a win screen with stats (Forest Health, nodes claimed, peak network size).
  *Done when: surviving all four seasons with healthy trees shows a victory screen.*

- [ ] **Day 24 — Lose conditions**
  Implement both lose triggers: Mother Fungus starvation (0 Sugar AND 0 Water for 30 continuous seconds), and network collapse (60%+ segments die in a single season). Show a loss screen explaining what went wrong.
  *Done when: deliberately starving yourself or overextending into Winter triggers a clear game-over.*

- [ ] **Day 25 — Full-run playtest + tuning**
  Play 3–5 complete runs. Tune season durations, multipliers, and starting resources. Target 15–25 minutes total. Key questions: Is Spring too boring? Does Winter feel survivable but tense? Is the win threshold too easy/hard?
  *Done when: a full run feels like a complete arc with rising tension and a satisfying resolution.*

---

## Phase 4 — Polish & Ship (Days 26–40)

> Goal: procedural maps, fog, competitors (maybe), menus, audio, publish.

### Week 6 — Map Generation & Fog

- [ ] **Day 26 — Procedural map generation**
  Replace the fixed map with a seeded generator: fill depth bands, scatter nodes by probability table, place trees, guarantee starter resources within 8 tiles of Mother Fungus. Generate a new map on each "New Run".
  *Done when: every run has a different but fair map layout.*

- [ ] **Day 27 — Fog of Soil**
  Add a dark overlay TileMap layer. All tiles start hidden. Tiles within 4 tiles of any living hypha are revealed (0.3s fade). Revealed tiles stay visible permanently even if the hypha dies.
  *Done when: the map starts dark and lights up as the network explores.*

- [ ] **Day 28 — Ghost path preview**
  When hovering near a hypha tip, show a dotted translucent line from the tip toward the cursor along a valid tile path. Tint it red if the player can't afford the cost. Use a simple A* or BFS through the grid. Skip Rock tiles if unaffordable.
  *Done when: you can see where your next segment will go before clicking.*

- [ ] **Day 29 — Dormant Spore nodes**
  Add 1–2 Dormant Spore nodes (white shimmer) per map. Reaching one grants a random bonus from the unlocked ability pool (or a small Sugar/Water bonus if nothing is unlocked). Show a brief popup with the reward.
  *Done when: reaching a spore node gives a clear reward and the node is consumed.*

- [ ] **Day 30 — Meta-progression**
  Track three unlock conditions across runs (Deep Roots, Spore Memory, Resistant Strain). Save unlocked state to browser localStorage. Show an "Unlocks" screen from the title menu. Apply unlocked effects during gameplay.
  *Done when: winning a run with Forest Health > 80% permanently unlocks Deep Roots for future runs.*

### Week 7 — Competitors & UI

- [ ] **Day 31 — Competitor fungi (CUT if behind schedule)**
  Spawn 1–2 AI fungi at map edges. Every N seconds they grow one segment toward the nearest unclaimed node. They use a dull orange colour. They claim nodes spatially (player can't use a claimed node).
  *Done when: orange networks slowly creep across the map claiming nodes.*

- [ ] **Day 32 — Competitor tuning (CUT if Day 31 was cut)**
  Competitors speed up in Autumn (from the GDD table). They take damage from Toxic pockets. Tune their spread rate so they feel like gentle pressure, not unfair aggression.
  *Done when: competitors create interesting spatial decisions without feeling punishing.*

- [ ] **Day 33 — Title screen + pause menu**
  Title screen: game logo (styled text is fine), "New Run", "Unlocks", "Settings" buttons. Pause (Escape): "Resume", "Restart Run", "Quit to Menu". Settings: volume sliders only.
  *Done when: you can start a run, pause it, restart, and return to the menu cleanly.*

- [ ] **Day 34 — Results screen**
  Win and lose screens show: Forest Health, total nodes claimed, peak network size, season survived to. "Play Again" starts a new run. "Menu" returns to title. Keep it simple — no animations.
  *Done when: every run ends with a clear summary of how it went.*

- [ ] **Day 35 — Tutorial tooltips**
  On the first run (check `has_seen_tutorial` flag), show 3–4 tooltip popups during Spring's first 60 seconds: "Click near a tip to grow", "Connect to tree roots for Sugar", "Right-click to prune". Dismiss on click. Save the flag so they never appear again.
  *Done when: a brand-new player gets enough guidance to understand the controls without a manual.*

### Week 8 — Audio & Ship

- [ ] **Day 36 — Generate music**
  Use Suno.ai (or similar) to generate 4 ambient tracks, one per season. Target: warm organic for Spring, bright for Summer, melancholic for Autumn, sparse and tense for Winter. Export as OGG. Drop them in the project.
  *Done when: you have 4 loopable tracks that feel distinct.*

- [ ] **Day 37 — SFX + AudioManager**
  Gather 8–10 SFX from freesound.org (grow squelch, root connection chime, prune snap, node claim, toxic warning, season transition, win jingle, lose sting). Wire them to gameplay events via the AudioManager node.
  *Done when: every major action has audio feedback.*

- [ ] **Day 38 — HTML5 export + browser testing**
  Export final HTML5 build. Test in Chrome, Firefox, and Safari. Fix any WebGL issues, audio autoplay restrictions, or resolution problems. Test at different window sizes.
  *Done when: the game runs cleanly in all three browsers.*

- [ ] **Day 39 — Bug-fix + performance pass**
  Play 5+ runs looking for bugs. Profile for frame drops with large networks (200+ segments). If needed: batch Line2D nodes or reduce Bézier subdivisions. Fix any edge cases (pruning during growth animation, connecting to a dead tree, etc.).
  *Done when: you can't crash the game by playing normally.*

- [ ] **Day 40 — Publish to itch.io**
  Create an itch.io page. Upload the HTML5 build. Write a short description, add a screenshot or GIF, set the tag "biological strategy". Share it. You finished a game.
  *Done when: someone else can play your game in their browser.*

---

## Emergency Cuts

If you're falling behind, cut in this order:

1. **Competitor fungi** (Days 31–32) — seasonal pressure is enough
2. **Meta-progression** (Day 30) — the core run already has a win state
3. **Dormant Spore nodes** (Day 29) — nice-to-have variety
4. **Ghost path preview** (Day 28) — players will learn to eyeball distances
5. **Fog of Soil** (Day 27) — game works fine with a visible map

Cutting all five saves you a full week and the game is still complete.