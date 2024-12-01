@tool
extends Sprite2D

var skew_dir = 1
@export var initial_skew =  randf() * 0.2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	skew += skew_dir * delta * 0.06
	if skew > 0.1:
		skew_dir = -1
	if skew < 0:
		skew_dir = 1
	pass
