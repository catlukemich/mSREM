extends Node2D

func go_to_main_screen() -> void:
	get_tree().change_scene_to_file("res://scenes/main_screen.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
