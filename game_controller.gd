extends Node2D
class_name GameController

@onready var camera: CameraController = $Camera2D
@onready var mother_fungus: MotherFungus = $MotherFungus
@onready var tilemap: MapController = $Map

var _mother_fungus_tile: Vector2i
var _hyphae_segments: Dictionary[Vector2i, Hyphae] = {}
var _current_sugar: int

var hyphae = preload('res://entities/hyphae.tscn')

func _ready() -> void:
  _mother_fungus_tile.x = randi_range(round(tilemap.horizontal_tiles_number / 2) - 10, round(tilemap.horizontal_tiles_number / 2) + 10)
  _mother_fungus_tile.y = randi_range(2, 10)

  mother_fungus.position = tilemap.map_to_local(_mother_fungus_tile)
  camera.position = mother_fungus.position
  camera.clamp_position()

  _current_sugar = Config.starting_sugar

  
func _process(_delta: float) -> void:
  if (Input.is_action_just_pressed('click') && _current_sugar > 0):
    _expand_network()

func _expand_network() -> void:
  var target_tile: Vector2i = tilemap.local_to_map(get_global_mouse_position())

  # Avoid expanding if the clicked tile already has a segment
  if (_hyphae_segments.has(target_tile)):
    return

  var surrounding_tiles = [
    Vector2i(target_tile.x, target_tile.y - 1),
    Vector2i(target_tile.x + 1, target_tile.y),
    Vector2i(target_tile.x, target_tile.y + 1),
    Vector2i(target_tile.x - 1, target_tile.y)
  ]

  var possible_connections: Array[Vector2i] = []
  for tile in surrounding_tiles:
    if (tile == _mother_fungus_tile):
      possible_connections.append(_mother_fungus_tile)

    if (_hyphae_segments.has(tile) && _hyphae_segments.get(tile).is_tip):
      possible_connections.append(tile)
      # Remove previous tips if they're connecting to this new segment
      _hyphae_segments.get(tile).is_tip = false
    

  if (possible_connections.size() > 0):
    var new_hyphae_segment: Hyphae = hyphae.instantiate()
    new_hyphae_segment.create(target_tile, possible_connections, tilemap)

    add_child(new_hyphae_segment)
    _hyphae_segments.set(target_tile, new_hyphae_segment)

  # Deduct sugar
  _current_sugar -= 1
