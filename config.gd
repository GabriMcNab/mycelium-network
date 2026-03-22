extends Node

@export var map_rect: Rect2 = Rect2(0, 0, 3840, 2560)

# Gameplay adjustment
@export var starting_sugar = 30 # units
@export var starting_water = 20 # units
@export var starting_minerals = 0 # units
@export var topsoil_growth_cost = 2 # Sugar per tile
@export var clay_growth_cost = 4 # Sugar per tile
@export var rock_growth_cost = 6 # Sugar per tile
@export var fork_cost_multiplier = 1.5 # x base tile cost
@export var prune_sugar_recovery = 0.3 # 30% of original cost
@export var water_maintenance_per_segment = 0.02 # Water/sec
@export var segment_death_rate_at_0_water = 0.5 # 1 segment / 2 sec
@export var birch_sugar_per_sec = 1.0 # per connected tree
@export var pine_sugar_per_sec = 2.5 # per connected tree
@export var oak_sugar_per_sec = 6.0 # per connected tree
@export var birch_mineral_cost_per_sec = 0.5 # per connected tree
@export var pine_mineral_cost_per_sec = 1.0 # per connected tree
@export var oak_mineral_cost_per_sec = 2.0 # per connected tree
@export var mother_fungus_starvation_timer = 30 # seconds
@export var network_collapse_threshold = 0.6 # 60% segments lost
@export var win_threshold_forest_health = 0.6 # 60%
@export var spring_duration = 240 # seconds (~4 min)
@export var summer_duration = 360 # seconds (~6 min)
@export var autumn_duration = 300 # seconds (~5 min)
@export var winter_duration = 300 # seconds (~5 min)
