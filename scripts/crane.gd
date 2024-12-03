@tool

extends Node3D

@export var enabled = true
@export var global_speed_coefficient = 0.1


var rot_dir = 1
var hook_dir = 1
var next_random = 0
var next_target_rot = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hook_dir = 1
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not enabled: return
	
	
	# Rotate myself a little bit to right and left
	var scaffold = $Stand/Scaffold
	scaffold.rotation_degrees.y += 100 * delta * rot_dir * global_speed_coefficient * (next_random + 0.5) 
	
	if scaffold.rotation_degrees.y >  25 - next_random * 40:
		rot_dir = -1
		next_random = randf()
	elif scaffold.rotation_degrees.y < -25 + next_random * 50:
		rot_dir = 1
		next_random = randf()
	
	
	# Move the hook forward and back
	var hook = $Stand/Scaffold/HookCompound
	hook.position.x += delta * 10 * hook_dir * global_speed_coefficient
	if hook.position.x > 10:
		hook_dir = -1
		next_random = randf()
	elif hook.position.x < -5:
		hook_dir = 1
		next_random = randf()
	
	pass
