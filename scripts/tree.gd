@tool
extends Sprite2D

var skew_dir = 1
@export var initial_skew =  randf() * 0.2

@export var trees_images_list: Array[Texture]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	texture = trees_images_list.pick_random()
	modulate.r = 1 + randf() * 0.3 - 0.3
	modulate.g = 1 + randf() * 0.3 - 0.3
	
	 
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	skew += skew_dir * delta * 0.06
	if skew > 0.1:
		skew_dir = -1
	if skew < 0:
		skew_dir = 1
	pass
