@tool
class_name DestructibleTileMapLayer
extends TileMapLayer

var _gridData: Dictionary

func _ready():
	if Engine.is_editor_hint():
		return
	
	var cells = get_used_cells()
	for cell_pos in cells:
		var cell_data: TileData = get_cell_tile_data(cell_pos)
		_gridData[cell_pos] = CustomTileData.new(cell_data.get_custom_data("destructible"), 
				cell_data.get_custom_data("hit_points"), 
				cell_data.get_custom_data("resource"), 
				cell_data.get_custom_data("resource_qty"))


func _get_configuration_warnings() -> PackedStringArray:
	var warnings = []

	if tile_set != null:
		if tile_set.get_custom_data_layer_by_name("destructible") == -1:
			warnings.append("The Tileset is missing destructible custom layer")
		if tile_set.get_custom_data_layer_by_name("hit_points") == -1:
			warnings.append("The Tileset is missing hit_points custom layer")
		if tile_set.get_custom_data_layer_by_name("resource") == -1:
			warnings.append("The Tileset is missing resource custom layer")
		if tile_set.get_custom_data_layer_by_name("resource_qty") == -1:
			warnings.append("The Tileset is missing resource_qty custom layer")

	return warnings


func damage_tile(collision_pos: Vector2, damage: int) -> void:
	var map_pos: Vector2i = local_to_map(to_local(collision_pos))
	print(map_pos)
	var atlas_coord = get_cell_atlas_coords(map_pos)
	print(atlas_coord)

	if _gridData[map_pos].destructible:
		_gridData[map_pos].hit_points -= damage
		if _gridData[map_pos].hit_points <= 0:
			_destroy_tile(map_pos)


func _destroy_tile(pos: Vector2) -> void:
	set_cell(pos, -1)


class CustomTileData:
	var destructible: bool
	var hit_points: int
	var resource: String
	var resource_qty: int

	# Constructor
	func _init(p_destructible: bool = false, p_hit_points: int = 0, p_resource: String = "", p_resource_qty: int = 0):
		destructible = p_destructible
		hit_points = p_hit_points
		resource = p_resource
		resource_qty = p_resource_qty
