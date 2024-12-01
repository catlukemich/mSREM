extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_mouse_entered() -> void:
	$"../Cloud".modulate = Color(1,1,1,0.4)
	pass # Replace with function body.


func _on_mouse_exited() -> void:
	$"../Cloud".modulate = Color(1,1,1,1)
	pass # Replace with function body.
