@tool
@icon("res://addons/icons/car.png")
extends Node2D

@export var car_8_directions_images: Array[Texture]
@export var car_speed: float = 100

var current_velocity_vector : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Press"):
		var agent : NavigationAgent2D = $NavigationAgent2D
		agent.target_position = get_global_mouse_position()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var agent : NavigationAgent2D = $NavigationAgent2D
	
	if Engine.is_editor_hint():
		agent.target_position = get_global_mouse_position()
		if agent.is_navigation_finished(): 
			print("finished!")
			return
	var current_position = global_position
	var next = agent.get_next_path_position()
	var to_vector = current_position.direction_to(next)
	
	agent.set_velocity(to_vector)
	position += to_vector * delta * car_speed
	
	var the_8_dir_vectors = [
		Vector2(1, -1), # up - right
		Vector2(1, 0), 
		Vector2(1, 1),
		Vector2(0, 1),
		Vector2(-1, 1),
		Vector2(-1, 0),
		Vector2(-1, -1),
		Vector2(0, -1), # up
	]
	
	
	var corrected_to_vector = Vector2(to_vector)
	corrected_to_vector.y *= 2 # Due to isometric grid problems
	
	if agent.is_navigation_finished(): 
		print("finished!")
		return
	for index in range(0,8):
		var cur_dir_vec = the_8_dir_vectors[index].normalized()
		#var dot_value = cur_dir_vec.angle_to(to_vector./normalized())
		var the_angle = rad_to_deg(cur_dir_vec.angle_to(corrected_to_vector.normalized()))
		#if dot_value  > 0.3 and dot_value <= 1:
		if the_angle < 22.5 and the_angle > -22.5:
			#print(rad_to_deg(the_angle))
			set_current_dir(index)
			#print(index)
			break 
			
func set_current_dir(index):
		$CarSprite.texture = car_8_directions_images[index]
		$CarSprite.rotation_degrees = -index * 45
		rotation_degrees = index * 45
		

func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	current_velocity_vector = safe_velocity
	pass # Replace with function body.
