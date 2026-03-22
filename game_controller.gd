extends Node2D
class_name GameController

@onready var camera: CameraController = $Camera2D
@onready var mother_fungus: MotherFungus = $MotherFungus

func _ready() -> void:
  mother_fungus.position.x = randf_range(Config.map_rect.size.x / 2 - 320, Config.map_rect.size.x / 2 + 320)
  mother_fungus.position.y = randf_range(160, 320)

  camera.position = mother_fungus.position
  camera.clamp_position()
