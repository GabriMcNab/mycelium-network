class_name MapController
extends TileMapLayer

const TOP_LAYER_TERRAIN_ID = 0
const MID_LAYER_TERRAIN_ID = 1
const BOTTOM_LAYER_TERRAIN_ID = 2

# Used to tweak the border irregularity between each layer
@export_range(0, 0.5) var border_variance_factor: float = 0.2
@export var mother_fungus: MotherFungus

var tile_pixel_size = 32
var horizontal_tiles_number: int
var vertical_tiles_number: int

func _ready() -> void:
  horizontal_tiles_number = int(round(Config.map_rect.size.x / tile_pixel_size))
  vertical_tiles_number = int(round(Config.map_rect.size.y / tile_pixel_size))
  _draw_tiles()

func _process(_delta: float) -> void:
  (material as ShaderMaterial).set_shader_parameter("mouse_position", get_local_mouse_position())

func _draw_tiles():
  var third = floori(vertical_tiles_number / 3.0)

  # Use noise to generate an irregular border between layers
  var noise = FastNoiseLite.new()
  noise.seed = randi()
  noise.frequency = 0.05
  var border_variance = third * border_variance_factor

  var top_layer_cells: Array[Vector2i] = []
  var mid_layer_cells: Array[Vector2i] = []
  var bot__layer_cells: Array[Vector2i] = []

  for x in horizontal_tiles_number:
    var first_layer_offset = int(noise.get_noise_1d(x) * border_variance)
    var second_layer_offset = int(noise.get_noise_1d(x + horizontal_tiles_number) * border_variance)

    var first_border = third + first_layer_offset
    var second_border = third * 2 + second_layer_offset
    for y in vertical_tiles_number:
      var cell = Vector2i(x, y)
      if y < first_border:
        top_layer_cells.append(cell)
      elif y < second_border:
        mid_layer_cells.append(cell)
      else:
        bot__layer_cells.append(cell)

  set_cells_terrain_connect(top_layer_cells, 0, TOP_LAYER_TERRAIN_ID)
  set_cells_terrain_connect(mid_layer_cells, 0, MID_LAYER_TERRAIN_ID)
  set_cells_terrain_connect(bot__layer_cells, 0, BOTTOM_LAYER_TERRAIN_ID)
