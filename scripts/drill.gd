extends RayCast2D

var _canDrill : bool = true
@onready var _cooldown: Timer = $CoolDown
@onready var Vartolo: CharacterBody2D = $".."

func _ready():
	Vartolo.character_movement.connect(_on_vartolo_movement)

func _physics_process(_delta: float) -> void:

	if is_colliding() and _canDrill:
		var map = get_collider()
		if map is DestructibleTileMapLayer:
			var collision_position := get_collision_point() 
			map.damage_tile(collision_position, 1)
		_canDrill = false
		_cooldown.start()
		
func _on_cool_down_timeout() -> void:
	_canDrill = true

func _on_vartolo_movement() -> void:
	var input_vector = Vartolo.direction
	match input_vector:
		Vector2(1, 0):
			print('Right')
			rotation_degrees = 270
		Vector2(-1, 0):
			print('Left')
			rotation_degrees = 90
		Vector2(0, 1):
			print('Down')
			rotation_degrees = 0
		Vector2(0, -1):
			print('Up')
			rotation_degrees = 180
