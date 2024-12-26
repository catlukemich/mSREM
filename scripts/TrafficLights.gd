class_name TrafficLights
extends Node2D

signal state_changed(state: int)


@export var change_duration = 8
@export var yellow_duration = 3


enum LightState { NS = 1, WE = 2, YELLOW = 3}

var state = LightState.NS
const states_sequence = [1, 3, 2, 3]
var current_state_index = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	switch_state()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func switch_state():
	current_state_index += 1
	current_state_index = current_state_index % 4
	state = states_sequence[current_state_index]		

	state_changed.emit(state)

	update_sprites()
	
func update_sprites():
	var all = [
		$Front1, $Front2, $FrontYellow
	]
	for single in all:
		single.hide()
		
	all[state - 1].show()
	


func _on_timer_timeout() -> void:
	switch_state()
	if state == LightState.YELLOW:
		$Timer.start(yellow_duration)
	else:
		$Timer.start(change_duration)
		
	pass # Replace with function body.
