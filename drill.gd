extends RayCast2D

var _canDrill : bool = true
@onready var _cooldown: Timer = $CoolDown


func _physics_process(_delta: float) -> void:
	
	if is_colliding() and _canDrill:
		var map: DestructibleTileMapLayer = get_collider()
		var collision_position := get_collision_point() 
		map.damage_tile(collision_position, 1)
		_canDrill = false
		_cooldown.start()


func _on_cool_down_timeout() -> void:
	_canDrill = true
