extends CharacterBody2D

const SPEED = 30 # Not being used!

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var goals : Dictionary = {}

var patrol_state = {
	"direction" = null # WHY THE FUCK DO I HAVE TO SET THIS ???
}

func _patrol(arr) -> void:
	const internal_speed = 30
	
	var current_char = self
	# Atrocious workaround to avoid using direct global vars, but its an object anyway so
	# Didn't find a way to access something like a scope intance or sum
	# set() get() use self by default here i think
	var direction = patrol_state["direction"] if patrol_state["direction"] != null else arr[0]
	var delta = arr[1]

	# Move until you collide
	if(current_char.move_and_collide(direction * internal_speed * delta)):
		# Change direction
		direction *= -1
		animated_sprite.flip_h = !animated_sprite.flip_h
	
	# Update the state
	patrol_state.direction = direction

func _follow(arr) -> void:
	var current_char = self
	var target_char = arr[0]
	var delta = arr[1]
	const internal_speed = 40
	# Get direction towards player
	var direction = (target_char.position - position).normalized()
	# Get new position
	var new_pos = direction * internal_speed * delta
	# Move until collision
	current_char.move_and_collide(new_pos) 

func _ready() -> void:
	goals["patrol"] = {
		"priority": 1,
		"function": _patrol,
		"params": [Vector2(1,0)],
		"state": ["delta"]
	}

func _physics_process(delta: float) -> void:
	var goal_list = goals.values()
	var current_goal = null
	var highest_goal = 0
	
	for goal in goal_list:
		if goal.priority > highest_goal:
			current_goal = goal
			highest_goal = goal.priority
	
	var state = { "delta": delta } # Really struggling to find shit in the docs
	
	var expected_state = []
	
	for var_name in current_goal.state:
		expected_state.push_back(state.get(var_name))
	
	var args = current_goal.params + expected_state
	
	# NOTE: i think this passes "self" already
	current_goal.function.call(args)

func _on_danger_zone_body_entered(body: Node2D) -> void:
	# FIX: there must be a tag system of something, not a fan of the following condition
	if (body is CharacterBody2D and not (body.name == "Enemy")): # For some reason "not self" didn't work
		goals["follow"] = {
			"priority": 5,
			"function": _follow,
			"params": [body],
			"state": ["delta"]
		}

func _on_out_danger_zone_body_exited(body: Node2D) -> void:
	if (body is CharacterBody2D):
		goals.erase("follow")
