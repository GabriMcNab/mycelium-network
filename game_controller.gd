extends Node2D
class_name GameController

@onready var camera: CameraController = $Camera2D
@onready var mother_fungus: MotherFungus = $MotherFungus
@onready var tilemap: MapController = $Map

func _ready() -> void:
  var mother_fungus_position = Vector2.ZERO
  mother_fungus_position.x = randf_range(tilemap.horizontal_tiles_number / 2 - 10, tilemap.horizontal_tiles_number / 2 + 10)
  mother_fungus_position.y = randi_range(2, 10)

  mother_fungus.position = tilemap.map_to_local(mother_fungus_position)
  camera.position = mother_fungus.position
  camera.clamp_position()

func _process(_delta: float) -> void:
  if (Input.is_action_just_pressed('click')):
    var mouse_position = get_local_mouse_position()
    var clicked_tile = tilemap.local_to_map(mouse_position)
    print(clicked_tile)
