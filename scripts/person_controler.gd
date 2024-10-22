extends CharacterBody2D

signal character_movement
@export var speed: float = 100.0
@onready var _animation_tree: AnimationTree = $AnimationTree
var direction: Vector2 = Vector2.ZERO
# Llamado cuando el nodo entra en el árbol de la escena por primera vez.
func _ready() -> void:
	$AnimationPlayer.play('idle')

# Llamado cada frame. 'delta' es el tiempo transcurrido desde el frame anterior.
func _physics_process(_delta: float) -> void:
	var input_vector := Vector2.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	input_vector = input_vector.normalized()
	#print(input_vector)
	velocity = input_vector * speed
	
	if input_vector != Vector2.ZERO:
		e_run(input_vector)
		character_movement.emit()
		direction = input_vector
	else:
		e_idle()
		direction = Vector2.ZERO
	
	move_and_slide()

# TODO: Hacer que el personaje siempre mire para un lado
# cuando se detiene
func e_run(value: Vector2) -> void:
	_animation_tree.get("parameters/playback").travel("run")
	_animation_tree.set("parameters/run/blend_position", value)

func e_idle() -> void:
	_animation_tree.get("parameters/playback").travel("idle")
