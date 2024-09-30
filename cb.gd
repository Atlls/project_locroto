extends CharacterBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play('siu')


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var direction = Input.get_vector('ui_left', 'ui_right','ui_up','ui_down')
	
	velocity = direction * 100
	move_and_slide()
