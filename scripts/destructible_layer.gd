@tool
class_name DestructibleTileMapLayer
extends TileMapLayer
## Node to handle destructible tiles in a tilemap layer
##
## This node extends TileMapLayer and adds functionality to handle destructible tiles.[br]
## For it to work you must use a tileset with the appropiate custom data layers.

# Dictionary to store grid data
var _grid_data: Dictionary


# Called when the node is added to the scene
func _ready():
	if Engine.is_editor_hint():
		return
	
	# Get all used cells in the tilemap
	var cells = get_used_cells()
	for cell_pos in cells:
		# Get tile data for each cell
		var cell_data: TileData = get_cell_tile_data(cell_pos)
		# Store custom tile data in the grid data dictionary
		_grid_data[cell_pos] = CustomTileData.new(
			cell_data.get_custom_data("is_destructible"), 
			cell_data.get_custom_data("hit_points"), 
			cell_data.get_custom_data("resource"), 
			cell_data.get_custom_data("resource_qty")
		)


# Returns configuration warnings for the tilemap layer
func _get_configuration_warnings() -> PackedStringArray:
	var warnings = []

	# Check if the tileset has the required custom data layers
	if tile_set != null:
		if tile_set.get_custom_data_layer_by_name("is_destructible") == -1:
			warnings.append("The Tileset is missing the is_destructible custom layer")
		if tile_set.get_custom_data_layer_by_name("hit_points") == -1:
			warnings.append("The Tileset is missing the hit_points custom layer")
		if tile_set.get_custom_data_layer_by_name("resource") == -1:
			warnings.append("The Tileset is missing the resource custom layer")
		if tile_set.get_custom_data_layer_by_name("resource_qty") == -1:
			warnings.append("The Tileset is missing the resource_qty custom layer")

	return warnings


## Damages a tile at the given collision position
func damage_tile(collision_pos: Vector2, damage: int) -> void:
	# Convert collision position to map position
	var map_pos: Vector2i = local_to_map(to_local(collision_pos))

	# Check if the tile is destructible and apply damage
	if _grid_data[map_pos].is_destructible:
		_grid_data[map_pos].hit_points -= damage
		# Destroy the tile if hit points are depleted
		if _grid_data[map_pos].hit_points <= 0:
			_destroy_tile(map_pos)


# Destroys a tile at the given position
func _destroy_tile(pos: Vector2) -> void:
	set_cell(pos, -1)


## Class to store custom tile data
class CustomTileData:
	var is_destructible: bool
	var hit_points: int
	var resource: String
	var resource_qty: int

	# Constructor
	func _init(p_destructible: bool = false, p_hit_points: int = 0, p_resource: String = "", p_resource_qty: int = 0):
		is_destructible = p_destructible
		hit_points = p_hit_points
		resource = p_resource
		resource_qty = p_resource_qty
