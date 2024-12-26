@tool
@icon("res://icons/train.png")
extends Node2D

@export var train_16_directions_images: Array[Texture]
@export var wagon_16_directions_images: Array[Texture]
@export var btn_reset : bool:
	set(v): reset()
@export var speed: float = 100
@export var travel_path : Path2D
@export var num_wagons : int = 5
var wagons : Array[Sprite2D]
var distance_so_far = 0
var scene_position: Vector2 # Scene position taken from the front sprite (the locomotive)
var scene_offset: Vector2 # The offset - as above ^

var current_velocity_vector : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scene_position = $FrontSprite.position
	scene_offset = $FrontSprite.offset
	for i in range(num_wagons):
		var wagon = Sprite2D.new()
		#wagon.y_sort_enabled = true
		wagons.append(wagon)
		add_child(wagon)
		wagon.scale.x = 0.4
		wagon.scale.y = 0.4
		wagon.offset.y
	pass # Replace with function body.

func _input(event: InputEvent) -> void:
	pass
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if travel_path == null: return

	var new_position = travel_path.curve.sample_baked(distance_so_far)
	
	
	distance_so_far += delta * speed
	if distance_so_far > travel_path.curve.get_baked_length():
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
			
	process_wagons()
	
func process_wagons():

	var WAGON_OFFSET = 50
	for wagon_idx in range(len(wagons)):
		
		var wagon = wagons[wagon_idx]
		var offset = WAGON_OFFSET * (wagon_idx + 1)
		var fwd_position = travel_path.curve.sample_baked(distance_so_far - offset + WAGON_OFFSET)
		var new_position = travel_path.curve.sample_baked(distance_so_far - offset)
		var delta_vec = new_position - position
		# TODO Check if the wagon will fit in the beginning of the curve
		
		
		var the_16_dir_vectors = []
		var north = Vector2(1, -1)
		the_16_dir_vectors.append(north)
		
		var curr_dir = north
		for i in range(0,15):
			curr_dir = curr_dir.rotated(deg_to_rad(22.5))
			curr_dir.y *= 2
			curr_dir = curr_dir.normalized()
			the_16_dir_vectors.append(curr_dir)
		
		var to_vector = (fwd_position - new_position).normalized()
		
		wagon.position = delta_vec
		wagon.position += scene_position
		wagon.offset.y = -400

		for index in range(0,16):
			var cur_dir_vec = the_16_dir_vectors[index].normalized()
			#var dot_value = cur_dir_vec.angle_to(to_vector./normalized())
			var the_angle = rad_to_deg(cur_dir_vec.angle_to(to_vector.normalized()))
			#if dot_value  > 0.3 and dot_value <= 1:
			if the_angle < 22.5 / 2 and the_angle > -22.5 / 2:
				wagon.texture = wagon_16_directions_images[index - 2]
				break 
		
	pass
			
func set_current_dir(index):
	$FrontSprite.texture = train_16_directions_images[index]
		
func reset():
	distance_so_far = 0
