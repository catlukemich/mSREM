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
	
func switch_state():
	var previous_state_index = current_state_index # Used below for updating
	current_state_index += 1
	current_state_index = current_state_index % 4
	state = states_sequence[current_state_index]		

	state_changed.emit(state)

	update_sprites(previous_state_index, current_state_index)
	
func update_sprites(prev_state_idx, curr_state_idx):
	var all_sprites = [
		$Front1, $Front2, $FrontYellow
	]

	var tween : Tween = self.get_tree().create_tween()
	for single in all_sprites:
		tween.set_parallel(true)
		tween.tween_property(single, "modulate", Color(1,1,1,0), 0.5)
		
	var curr_sprite = all_sprites[state - 1]
	tween.tween_property(curr_sprite, "modulate", Color(1,1,1,1), 0.5)


func _on_timer_timeout() -> void:
	switch_state()
	if state == LightState.YELLOW:
		$Timer.start(yellow_duration)
	else:
		$Timer.start(change_duration)
		
	pass # Replace with function body.
