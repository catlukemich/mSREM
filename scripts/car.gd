@tool
extends Node2D


var current_velocity_vector : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var agent : NavigationAgent2D = $NavigationAgent2D
	agent.target_position = get_global_mouse_position()
	var current_position = global_position
	var next = agent.get_next_path_position()
	var to_vector = current_position.direction_to(next)
	
	agent.set_velocity_forced(to_vector)
	position += to_vector * delta * 250
	


func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	current_velocity_vector = safe_velocity
	pass # Replace with function body.
