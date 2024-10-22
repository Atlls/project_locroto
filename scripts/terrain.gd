extends Node2D

@export var noise_height_text: NoiseTexture2D
var noise: Noise
# Tamano del mapa
var width: int = 1000
var height: int = 1000

@onready var tile_map_layer = $TileMapLayer

# Source del tilemap
var source_id = 0

# IDs directos de los tiles verde, rojo y azul en el TileSet
var green_tile_id = Vector2i(5, 0)  # Ajusta estos valores a los IDs correctos en tu TileSet
var brown_tile_id = Vector2i(18, 3)    # Ajusta estos valores a los IDs correctos en tu TileSet
var blue_tile_id = Vector2i(5, 6)    # Ajusta este valor al ID correcto en tu TileSet

func _ready():
	noise = noise_height_text.noise
	generate_world()

func generate_world():
	for x in range(width):
		for y in range(height):
			var noise_val = noise.get_noise_2d(x, y)
			var position = Vector2i(x, y)

			if noise_val >= 0.5: # Verde para valores altos de ruido
				tile_map_layer.set_cell(position, source_id, green_tile_id, 0)
			elif noise_val >= 0.0: # Rojo para valores medios
				tile_map_layer.set_cell(position, source_id, brown_tile_id, 0)
			else: # Azul para valores bajos
				tile_map_layer.set_cell(position, source_id, blue_tile_id, 0) 
