@tool
@icon("res://addons/icons/train.png")
extends Node2D

@export var train_16_directions_images: Array[Texture]
@export var btn_reset : bool:
	set(v): reset()
@export var car_speed: float = 100
@export var travel_path : Path2D
var distance_so_far = 0

var current_velocity_vector : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _input(event: InputEvent) -> void:
	pass
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if travel_path == null: return

	var new_position = travel_path.curve.sample_baked(distance_so_far)
	
	distance_so_far += delta * 400
	if distance_so_far > 6000:
		distance_so_far = 0
	
	
	var the_16_dir_vectors = []
	var north = Vector2(1, -1)
	the_16_dir_vectors.append(north)
	
	var curr_dir = north
	for i in range(0,15):
		curr_dir = curr_dir.rotated(deg_to_rad(22.5))
		curr_dir.y *= 2
		curr_dir = curr_dir.normalized()
		the_16_dir_vectors.append(curr_dir)
	
	var to_vector = (new_position - position).normalized()
	position = new_position

	for index in range(0,16):
		var cur_dir_vec = the_16_dir_vectors[index].normalized()
		#var dot_value = cur_dir_vec.angle_to(to_vector./normalized())
		var the_angle = rad_to_deg(cur_dir_vec.angle_to(to_vector.normalized()))
		#if dot_value  > 0.3 and dot_value <= 1:
		if the_angle < 22.5 / 2 and the_angle > -22.5 / 2:
			set_current_dir(index - 2)
			break 
			
func set_current_dir(index):
	$FrontSprite.texture = train_16_directions_images[index]
		
func reset():
	distance_so_far = 0
