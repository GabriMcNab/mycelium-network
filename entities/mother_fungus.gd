class_name MotherFungus
extends Node2D

const BASE_COLOR = Color(217, 255, 227) # bright bioluminescent green
const CORE_RADIUS = 16.0
const OUTER_RADIUS = 24.0

func _process(_delta: float) -> void:
  queue_redraw()

func _draw() -> void:
  # Pulse factor — breathes slowly
  var pulse = 0.85 + 0.15 * sin(Time.get_ticks_msec() / 800.0)
  # Outer glow — soft, transparent
  draw_circle(Vector2.ZERO, OUTER_RADIUS * pulse, BASE_COLOR * Color(1, 1, 1, 0.15))
  # Middle ring
  draw_circle(Vector2.ZERO, (CORE_RADIUS + 3.0) * pulse, BASE_COLOR * Color(1, 1, 1, 0.3))
  # Bright core
  draw_circle(Vector2.ZERO, CORE_RADIUS * pulse, BASE_COLOR)
  # White-hot center dot
  draw_circle(Vector2.ZERO, 3.0, Color.WHITE)