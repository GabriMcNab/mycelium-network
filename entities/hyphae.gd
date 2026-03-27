class_name Hyphae
extends Node2D

var tile: Vector2i
var connections: Array[Vector2i] = []
var is_tip: bool = false

var _tilemap: TileMapLayer

func create(tile_position: Vector2i, new_connections: Array[Vector2i], tilemap: MapController) -> void:
  tile = tile_position
  connections = new_connections
  _tilemap = tilemap

  if (connections.size() == 1):
    is_tip = true

func _draw():
  var tile_center = _tilemap.map_to_local(tile)

  for connection in connections:
    var connection_center = _tilemap.map_to_local(connection)
    draw_line(tile_center, connection_center, Color.WHITE, 2)
