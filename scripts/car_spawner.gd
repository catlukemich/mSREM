extends Node2D

@export var spawn_interval_in_seconds : float = 1
@export var objects_layer : Node2D # The tile map layer, where the isometric objects move on
@export var city_limits : TileMapLayer # The tilemap layer, where the city limits (signs) are set
@export var car_prototypes: Array[Car] # The prototypes, thta will get duplicated and instantiated as a new car


@export var btn_start: bool:
	set(value): $CountDownTimer.start()
	
@export var btn_stop: bool:
	set(value): $CountDownTimer.stop()

var last_entries_used : Array[Vector2] = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_count_down_timer_timeout() -> void:
	$CountDownTimer.wait_time = spawn_interval_in_seconds
	spawn_car()
	pass # Replace with function body.


func spawn_car():
	# Create new car instance and place it on screen.
	var index = randi() % len(car_prototypes)
	var random_car_prototype : Car = car_prototypes[index]
	var new_car : Car = random_car_prototype.duplicate()
	objects_layer.add_child(new_car)
	new_car.restart_recent_spawn_timer()
	
	# Get random entry and random exit
	var exit : Vector2 = get_random_limit([])
	
	var entry = get_next_entry()
	while exit == entry: #<-- Quick dirty hack to avoid entry being the same as exit
		exit = get_next_entry()
	
	# Realign used entries queue array
	last_entries_used.append(entry)
	if len(last_entries_used) == get_num_limits():
		last_entries_used.remove_at(0) # One is always left
	
	
	new_car.global_position = entry
	new_car.set_target_position(exit)
	
	
func get_next_entry() -> Vector2:
	return get_random_limit(last_entries_used)
	
	
func get_random_limit(exclude : Array[Vector2]) -> Vector2:
	var cells = city_limits.get_used_cells()
	if len(exclude) > 0:
		for excluded in exclude:
			cells.remove_at(cells.find(excluded)) # Remove where we don't want to spawn
	var cell = cells[randi() % len(cells)]
	var global_position = objects_layer.to_global(objects_layer.map_to_local(cell))
	return global_position
	
func get_num_limits() -> int:
	var cells = city_limits.get_used_cells()
	return len(cells)
	
