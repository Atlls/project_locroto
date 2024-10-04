extends CharacterBody2D

# Velocidad del dash
var dash_speed = 400

@onready var maquina_estados: AnimationTree = $AnimationTree

# Llamado cuando el nodo entra en el árbol de la escena por primera vez.
func _ready() -> void:
	$AnimationPlayer.play('idle')

func e_run(active:bool):
	maquina_estados['parameters/conditions/run'] = active
	maquina_estados['parameters/conditions/idle'] = not active
	
func e_idle(active:bool):
	maquina_estados['parameters/conditions/run'] = not active
	maquina_estados['parameters/conditions/idle'] = active

# Llamado cada frame. 'delta' es el tiempo transcurrido desde el frame anterior.
func _physics_process(delta: float) -> void:
	var direction = Input.get_vector('ui_left', 'ui_right', 'ui_up', 'ui_down')
	
	velocity = direction * 50

	if direction:
		e_run(true)
	else:
		e_idle(true)
	
	move_and_slide()
