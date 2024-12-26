@icon("res://icons/car.png")
class_name Car
extends Node2D


@export var car_8_directions_images: Array[Texture]
@export var car_target_speed: float = 100
@export var mouse_target_position: bool = false
@export var acceleration_speed = 0.3
@export var braking_speed = 4


var became_fucked_up = false
var car_current_speed : float
enum Acceleration {ACCELERATING, BRAKING, CONSTANT_SPEED}
var acceleration_state = Acceleration.ACCELERATING
var distance_to_obstacle = 100

var has_recently_spawned : bool #<-- A flag indicating if the car has spawned recently, used to avoid jams by spawning one car on another one
var safe_velocity : Vector2
var current_velocity_vector : Vector2
signal direction_changed_signal(direction : int, rotation_degrees : float)
var current_direction : int = 0: # Index of the current direction.
	set(index):
		current_direction = index
		var rotation_degrees = index * 45
		direction_changed_signal.emit(current_direction, rotation_degrees)
var current_lights : TrafficLights
var waiting_for_lights: bool = false
var passing_lights : TrafficLights
var just_pass_lights = false
#var passing_lights : TrafficLights
var do_fadeout = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	car_current_speed = 0 #<-- The cars start stopped (perhaps, should be running, when entering city limits)
	has_recently_spawned = true
	pass # Replace with function body.

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Press") and mouse_target_position:
		var agent : NavigationAgent2D = $NavigationAgent2D
		agent.target_position = get_global_mouse_position()

func _process(delta: float) -> void:
	var areas = $CarSprite/CarViewArea2D.get_overlapping_areas()
	
	var is_car_in_front = false
	
	for area in areas:
		#if area.name == "LightsCollisionArea2D":
			#passing_lights = area.get_traffic_lights()
		if area.name == "CarCollisionArea2D":
			var other_car = area.get_car() as Car
			is_car_in_front = check_is_car_in_front(other_car)
			if is_car_in_front: 
				distance_to_obstacle = (other_car.position - position).length()
				break
			else: 
				distance_to_obstacle = 50
	
	if not waiting_for_lights or just_pass_lights:
		#accelerate("Nobody in front of me")
		accelerate()
	else:
		brake()

	if is_car_in_front:
		brake()

	
	if acceleration_state == Acceleration.ACCELERATING:
		if car_current_speed < car_target_speed:
			car_current_speed += acceleration_speed
		if passing_lights != null:
			var lights_target_speed = car_target_speed / 2
			if car_current_speed < lights_target_speed:
				car_current_speed += acceleration_speed
			else:
				car_current_speed -= braking_speed
	elif acceleration_state == Acceleration.BRAKING:
		if car_current_speed > 0:
			#var braking_factor = 10 / clamp(distance_to_obstacle - 50, 51, 999999999999)
			#var delta_v = braking_speed * braking_factor
			#if delta_v < 0: delta_v = 0
			#car_current_speed -= braking_speed * braking_factor
			#if car_current_speed < 0: car_current_speed = 0
			car_current_speed -= braking_speed
			
		else: car_current_speed = 0
			
				
	if passing_lights != null:
		$CarSprite/LightsMarker.color = Color.RED
	else:
		$CarSprite/LightsMarker.color = Color.WHITE
		
	
	if do_fadeout:
		fade_out()
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var agent : NavigationAgent2D = $NavigationAgent2D
	if agent.target_position.distance_to(global_position) < 20:
		do_fadeout = true
		
	
	if Engine.is_editor_hint():
		if mouse_target_position:
			agent.target_position = get_global_mouse_position()
		if agent.is_navigation_finished(): 
			return
	var current_position = global_position
	var next = agent.get_next_path_position()
	var to_vector = current_position.direction_to(next)
	
	agent.set_velocity(to_vector)
	position += to_vector * delta * car_current_speed * 2
	
	
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

	for index in range(0,8):
		var cur_dir_vec = the_8_dir_vectors[index].normalized()
		var the_angle = rad_to_deg(cur_dir_vec.angle_to(corrected_to_vector.normalized()))
		#if dot_value  > 0.3 and dot_value <= 1:
		if the_angle < 22.5 and the_angle > -22.5:
			set_current_dir(index)
			break 
			
func set_target_position(target_position : Vector2):
	$NavigationAgent2D.target_position = target_position
			

# Set the current direction of the vehicle, 
# where 0 is north - east heading (↗) and
# subsequent values 
# 0 - ↗
# 1 - →
# 2 - ↘︎
# 3 - ↓
# 4 - ↙︎
# 5 - ←
# 6 - ↖
# 7 - ↑
func set_current_dir(index):
		$CarSprite.texture = car_8_directions_images[index]
		$CarSprite.rotation_degrees = -index * 45
		rotation_degrees = index * 45
		current_direction = index
		
func check_is_car_in_front(other_car):
	var areas = $CarSprite/CarViewArea2D.get_overlapping_areas()
	var own_area = $CarSprite/CarCollisionArea2D
	if len(areas) > 0:
		for area in areas:
			if area.name == "CarCollisionArea2D" and area != own_area:
				var car : Car = area.get_car()
				
				var likewise_directions = [
					(current_direction - 1) % 8,
					current_direction,
					(current_direction + 1) % 8,
				]
				
				if car.current_direction in likewise_directions:
					return true
				
	return false


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

func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	self.safe_velocity = safe_velocity
	pass # Replace with function body.


func _on_navigation_agent_2d_navigation_finished() -> void:
	do_fadeout = true
	$NavigationAgent2D.set_velocity(Vector2.ZERO)


func clear_recent_spawn_flag() -> void:
	has_recently_spawned = false
	$CarSprite/Polygon2D.color = Color.BROWN
	pass # Replace with function body.

func restart_recent_spawn_timer():
	$RecentlySpawnedFlagClearer.start()
	


func _on_car_view_area_2d_area_entered(area: Area2D) -> void:
	# Entering traffic lights
	if area.name == "LightsCollisionArea2D":  
		var lights : TrafficLights = area.get_traffic_lights()
		var can_go = check_can_go_through_lights(lights)
		if lights == passing_lights or just_pass_lights: 
			can_go = true
			waiting_for_lights = false
		
		passing_lights = lights
		
		if not can_go:
			became_fucked_up = true
			current_lights = lights
			lights.state_changed.connect(on_lights_leave)
			waiting_for_lights = true
			brake("Lights fucked up")
		else:
			$CarSprite/FuckedUp.color = Color.DEEP_PINK
			just_pass_lights = true
			$LightsCooldownTimer.start(3)

			
func _on_car_view_area_2d_area_exited(area: Area2D) -> void:
	if area.name == "LightsCollisionArea2D":  
		passing_lights = null
		print("leving lights!")
		accelerate()


func on_lights_leave(state: int):
	if check_can_go_through_lights(current_lights):
		waiting_for_lights = false
		became_fucked_up = false
		$CarSprite/FuckedUp.color = Color.DEEP_PINK
		just_pass_lights = true
		$LightsCooldownTimer.start()
		current_lights.state_changed.disconnect(on_lights_leave)

func cooldown_timeout() -> void:
	just_pass_lights = false
	pass # Replace with function body.


func brake(reason = null):
	if(reason):	print(reason)
	acceleration_state = Acceleration.BRAKING
	
	
func accelerate(reason = null):
	if(reason):	print(reason)
	acceleration_state = Acceleration.ACCELERATING


func fade_out():
	var color : Color = $CarSprite.modulate
	color.a -= 0.03
	$CarSprite.modulate = color
	if color.a == 0:
		get_parent().remove_child(self)
		
