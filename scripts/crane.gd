@tool
@icon("res://icons/crane.png")
extends Node2D

@export var enabled : bool = true
	#set(value):
		#enabled = value
		#%CraneModel.enabled = value
		
		
@export var global_speed_coefficient: float = 0.1
	#set(value):
		#global_speed_coefficient = value
		#%CraneModel.global_speed_coefficient = value
 #

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
