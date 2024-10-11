extends CharacterBody2D

@export var speed = 40.0

# Llamado cuando el nodo entra en el árbol de la escena por primera vez.
func _ready() -> void:
	$AnimationPlayer.play('idle')

func e_run(value: Vector2) -> void:
	$AnimationTree.get("parameters/playback").travel("run")
	$AnimationTree.set("parameters/run/blend_position", value)
	print(value)
	print('Run')

func e_idle() -> void:
	$AnimationTree.get("parameters/playback").travel("idle")
	print('Idle')


# Llamado cada frame. 'delta' es el tiempo transcurrido desde el frame anterior.
func _physics_process(delta: float) -> void:
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	velocity = input_vector * speed
	
	if input_vector != Vector2.ZERO:
		e_run(input_vector)
	else:
		e_idle()
	
	move_and_slide()
