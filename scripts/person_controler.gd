extends CharacterBody2D

# Velocidad del dash
var dash_speed = 400

# Llamado cuando el nodo entra en el árbol de la escena por primera vez.
func _ready() -> void:
	$AnimationPlayer.play('siu')

# Llamado cada frame. 'delta' es el tiempo transcurrido desde el frame anterior.
func _physics_process(delta: float) -> void:
	var direction = Input.get_vector('ui_left', 'ui_right', 'ui_up', 'ui_down')
	
	velocity = direction * 100
	
	# Detectar dash
	if Input.is_action_just_pressed('ui_accept'):
		velocity += direction * dash_speed
	
	move_and_slide()
