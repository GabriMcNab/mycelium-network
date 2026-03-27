extends Node2D
class_name GameController

@onready var camera: CameraController = $Camera2D
@onready var mother_fungus: MotherFungus = $MotherFungus
@onready var tilemap: TileMapLayer = $Map

func _ready() -> void:
  mother_fungus.position.x = randf_range(Config.map_rect.size.x / 2 - 320, Config.map_rect.size.x / 2 + 320)
  mother_fungus.position.y = randf_range(160, 320)

  camera.position = mother_fungus.position
  camera.clamp_position()

func _process(_delta: float) -> void:
  if (Input.is_action_just_pressed('click')):
    var mouse_position = get_local_mouse_position()
    var clicked_tile = tilemap.local_to_map(mouse_position)
    print(clicked_tile)
