class_name DestructibleTileMapLayer
extends TileMapLayer


func damage_tile(collision_pos: Vector2) -> void:
	print(collision_pos)
	var local_pos: Vector2 = to_local(collision_pos)
	var map_pos: Vector2i = local_to_map(to_local(collision_pos))
	var atlas_coord = get_cell_atlas_coords(map_pos)
	
