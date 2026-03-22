class_name CameraController
extends Camera2D

# - Zoom and Pan -
@export var pan_speed: int = 1000
@export var zoom_speed: float = 10
@export var zoom_smoothing: float = 5
@export var min_zoom: float = 2
@export var max_zoom: float = 0.5

func _ready() -> void:
  position = Vector2(Config.map_rect.size.x * 0.5, Config.map_rect.size.y * 0.5);

func _process(delta: float) -> void:
  _handle_pan(delta)
  _handle_zoom(delta)

func _handle_pan(delta: float) -> void:
  var pan_dir = Vector2.ZERO
  if (Input.is_action_pressed('pan_up')):
    pan_dir.y -= 1
  if (Input.is_action_pressed('pan_down')):
    pan_dir.y += 1
  if (Input.is_action_pressed('pan_left')):
    pan_dir.x -= 1
  if (Input.is_action_pressed('pan_right')):
    pan_dir.x += 1

  if (pan_dir != Vector2.ZERO):
    position += pan_dir.normalized() * pan_speed * delta / zoom.x
    clamp_position()

func _handle_zoom(delta: float):
  var mouse_position = get_viewport().get_mouse_position()
  var old_zoom = zoom.x
  var new_zoom = zoom.x

  if (Input.is_action_just_pressed("zoom_in")):
    var target_zoom = clampf((old_zoom + zoom_speed), max_zoom, min_zoom);
    new_zoom = lerpf(old_zoom, target_zoom, 1 - exp(-zoom_smoothing * delta))
  if (Input.is_action_just_pressed('zoom_out')):
    var target_zoom = clampf((old_zoom - zoom_speed), max_zoom, min_zoom);
    new_zoom = lerpf(old_zoom, target_zoom, 1 - exp(-zoom_smoothing * delta))

  if (new_zoom == old_zoom || absf(new_zoom - old_zoom) < 0.001):
    return

  # Zoom towards mouse cursor, not viewport center
  zoom = Vector2(new_zoom, new_zoom)
  var vp_size = get_viewport_rect().size

  var old_world_position = position + (mouse_position - vp_size / 2) / old_zoom
  var new_world_position = position + (mouse_position - vp_size / 2) / new_zoom

  position += old_world_position - new_world_position
  clamp_position()

func clamp_position() -> void:
  # Keep the camera within the map boundaries
  var vp_size = get_viewport_rect().size
  var half_view = vp_size / (2.0 * zoom.x)

  position.x = clampf(position.x, Config.map_rect.position.x + half_view.x, Config.map_rect.end.x - half_view.x)
  position.y = clampf(position.y, Config.map_rect.position.y + half_view.y, Config.map_rect.end.y - half_view.y)
