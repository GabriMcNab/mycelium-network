extends Node2D
class_name GameController

@onready var camera: CameraController = $Camera2D
@onready var mother_fungus: MotherFungus = $MotherFungus
@onready var tilemap: MapController = $Map

var mother_fungus_tile: Vector2i
var hyphae_segments: Dictionary[Vector2i, Hyphae] = {}

var hyphae = preload('res://entities/hyphae.tscn')

func _ready() -> void:
  mother_fungus_tile.x = randi_range(round(tilemap.horizontal_tiles_number / 2) - 10, round(tilemap.horizontal_tiles_number / 2) + 10)
  mother_fungus_tile.y = randi_range(2, 10)

  mother_fungus.position = tilemap.map_to_local(mother_fungus_tile)
  camera.position = mother_fungus.position
  camera.clamp_position()

  
func _process(_delta: float) -> void:
  if (Input.is_action_just_pressed('click')):
    _expand_network()

func _expand_network() -> void:
  var target_tile: Vector2i = tilemap.local_to_map(get_global_mouse_position())

  var surrounding_tiles = [
    Vector2i(target_tile.x, target_tile.y - 1),
    Vector2i(target_tile.x + 1, target_tile.y),
    Vector2i(target_tile.x, target_tile.y + 1),
    Vector2i(target_tile.x - 1, target_tile.y)
  ]

  var possible_connections: Array[Vector2i] = []
  for tile in surrounding_tiles:
    if (tile == mother_fungus_tile):
      possible_connections.append(mother_fungus_tile)

    if (hyphae_segments.has(tile) && hyphae_segments.get(tile).is_tip):
      possible_connections.append(tile)

  if (possible_connections.size() > 0):
    var new_hyphae_segment: Hyphae = hyphae.instantiate()
    new_hyphae_segment.create(target_tile, possible_connections, tilemap)

    add_child(new_hyphae_segment)
    hyphae_segments.set(target_tile, new_hyphae_segment)
