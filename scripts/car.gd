@icon("res://icons/car.png")
class_name Car
extends Node2D

 
@export var car_8_directions_images: Array[Texture]
@export var car_target_speed: float = 100
@export var mouse_target_position: bool = false
@export var acceleration_speed = 2.3
@export var braking_speed = 4

@onready var navigator = $NavigationAgent2D
@onready var view_area = $CarSprite/CarViewArea2D
@onready var collision_area = $CarSprite/CarCollisionArea2D
@onready var debug_label = $CarSprite/Label

var has_recently_spawned : bool # A flag indicating if the car has spawned recently, used to avoid jams by spawning one car on another one
var car_current_speed : float # The car starts stopped (perhaps, should be running, when entering city limits)
enum Acceleration {ACCELERATING, BRAKING, CONSTANT_SPEED}
var acceleration_state = Acceleration.ACCELERATING
var current_velocity_vector : Vector2
signal direction_changed_signal(direction : int, rotation_degrees : float)
var current_direction : int = 0: # Index of the current direction.
	set(index):
		current_direction = index
		var new_rotation_degrees = index * 45
		direction_changed_signal.emit(current_direction, new_rotation_degrees)

var current_lights : TrafficLights
var waiting_for_lights: bool = false
var passing_lights : TrafficLights
var just_pass_lights = false
var current_crossing : RoadCrossing = null
var current_crossing_priority = -1


var do_fadeout = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	car_current_speed = 0 
	has_recently_spawned = true
	pass # Replace with function body.
	

func _process(delta: float) -> void:
	var areas = view_area.get_overlapping_areas()
	if navigator.is_navigation_finished():
		get_parent().remove_child(self)
	
	# By default the car is free to go: 
	var is_car_in_front = false
	var can_go_through_crossing = true

	var num_cars_in_front = 0

	# Check if there are any obstacles 
	for area in areas:
		if area.name == collision_area.name and not is_car_in_front:
			var car : Car = area.get_car() as Car
			is_car_in_front = check_is_car_in_front(car)
			num_cars_in_front += 1
		if area.name == "RoadCrossingArea2D" and can_go_through_crossing:
			var crossing : RoadCrossing = area.get_road_crossing()
			crossing.register_car(self)
			can_go_through_crossing = check_can_go_through_crossing(crossing)
		

	if not waiting_for_lights or just_pass_lights:
		accelerate()
	else:
		brake()
	if is_car_in_front or not can_go_through_crossing:
		brake()

	# The acceleration and braking update part  
	if acceleration_state == Acceleration.ACCELERATING:
		if car_current_speed < car_target_speed:
			car_current_speed += acceleration_speed
		if passing_lights != null or current_crossing != null:
			var crossing_target_speed = car_target_speed / 2
			if car_current_speed < crossing_target_speed:
				car_current_speed += acceleration_speed
			else:
				car_current_speed -= braking_speed
	elif acceleration_state == Acceleration.BRAKING:
		if car_current_speed > 0:
			car_current_speed -= braking_speed
		else: car_current_speed = 0
			
	debug_label.text = \
			"Priority: %s\n" % current_crossing_priority + \
			"Direction: %s \n" % current_direction
	if is_car_in_front:
		debug_label.text += "CAR in front \n"
		debug_label.text += "number: %s " % num_cars_in_front

		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		if mouse_target_position:
			navigator.target_position = get_global_mouse_position()
		if navigator.is_navigation_finished(): 
			return
	var current_position = global_position
	var next = navigator.get_next_path_position()
	var to_vector = current_position.direction_to(next)
	
	navigator.set_velocity(to_vector)
	position += to_vector * delta * car_current_speed * 2
	
	var corrected_to_vector = Vector2(to_vector)
	corrected_to_vector.y *= 2 # Due to isometric grid problems

	for index in range(0,8):
		var cur_dir_vec = Concepts.vehicle_directions[index].normalized()
		var the_angle = rad_to_deg(cur_dir_vec.angle_to(corrected_to_vector.normalized()))
		#if dot_value  > 0.3 and dot_value <= 1:
		if the_angle < 22.5 and the_angle > -22.5:
			set_current_direction(index)
			break 
			

func set_target_position(target_position : Vector2):
	$NavigationAgent2D.target_position = target_position
			

func _on_navigation_agent_2d_navigation_finished() -> void:
	navigator.set_velocity(Vector2.ZERO)


func set_current_direction(index):
		$CarSprite.texture = car_8_directions_images[index]
		$CarSprite.rotation_degrees = -index * 45
		rotation_degrees = index * 45
		current_direction = index
		
		
func check_is_car_in_front(other_car : Car):
	var going_likewise_dir = Concepts.are_directions_likewise(self.current_direction, other_car.current_direction)
	return going_likewise_dir

func check_can_go_through_lights(lights: TrafficLights) -> bool:
	var state = lights.state
	if current_direction in [0,4]:
		if state == 2:
			return true
	if current_direction in [2,6]:
		if state == 1:
			return true
	
	if state == 3: # Yellow lights, nobody goes
		return false
	
	return false

func check_can_go_through_crossing(crossing : RoadCrossing) -> bool:
	# var approaching = false # a flag  indicating we are approaching the road crossing 
	if current_crossing == null and crossing != null:
		# approaching = true
		var priorities = crossing.get_priority()
		var approach_priority = priorities.find(current_direction) # Find out what would be that priority if we are approaching the road crossing 
		current_crossing_priority = approach_priority
		current_crossing = crossing

	# Get other cars on the car crossing 
	var crossings_cars : Array = crossing.get_registered_cars()
	if self in crossings_cars and len(crossings_cars) == 1:
		return true
	for other_car : Car in crossings_cars:
		if other_car == self: continue # We don't care about ourselves (the current car)
		var has_priority = false
		var goes_in_contrary_direction = false
		# can't continue if the other car has lower priority index:
		if other_car.current_crossing_priority > self.current_crossing_priority:
			has_priority = true
		if Concepts.are_directions_contrary(other_car.current_direction, self.current_direction):
			goes_in_contrary_direction = true

		if has_priority and not goes_in_contrary_direction:
			return true
		elif not has_priority and goes_in_contrary_direction:
			return true
	return false
	
		
func clear_recent_spawn_flag() -> void:
	has_recently_spawned = false


func restart_recent_spawn_timer():
	$RecentlySpawnedFlagClearer.start()
	

func _on_car_view_area_2d_area_entered(area: Area2D) -> void:
	var lights_area_name = "LightsCollisionArea2D"
	
	# Entering traffic lights
	if area.name == lights_area_name:  
		var lights : TrafficLights = area.get_traffic_lights()
		var can_go = check_can_go_through_lights(lights)
		if lights == passing_lights or just_pass_lights: 
			can_go = true
			waiting_for_lights = false
		
		passing_lights = lights
		
		if not can_go:
			current_lights = lights
			lights.state_changed.connect(on_lights_leave)
			waiting_for_lights = true
		else:
			just_pass_lights = true
			$LightsCooldownTimer.start(3)

	

func _on_car_view_area_2d_area_exited(area: Area2D) -> void:
	if area.name == "LightsCollisionArea2D":  
		passing_lights = null
		accelerate()

	var road_crossing_area_name = "RoadCrossingArea2D"
	if area.name == road_crossing_area_name:
		var crossing : RoadCrossing = area.get_road_crossing()
		crossing.deregister_car(self)


func on_lights_leave(state: int):
	if check_can_go_through_lights(current_lights):
		waiting_for_lights = false
		just_pass_lights = true
		$LightsCooldownTimer.start()
		current_lights.state_changed.disconnect(on_lights_leave)

func cooldown_timeout() -> void:
	just_pass_lights = false


func brake():
	acceleration_state = Acceleration.BRAKING
	
	
func accelerate():
	acceleration_state = Acceleration.ACCELERATING



		
