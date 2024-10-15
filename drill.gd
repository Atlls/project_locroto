extends RayCast2D

# Llamado cada frame. 'delta' es el tiempo transcurrido desde el frame anterior.
func _physics_process(_delta: float) -> void:
	
	if is_colliding():
		var map: DestructibleTileMapLayer = get_collider()
		var collision_position := get_collision_point() 
		map.damage_tile(collision_position)
