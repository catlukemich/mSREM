@tool
@icon("res://icons/cloud.png")
class_name Cloud
extends Node2D

#@export var cloud_image: Texture
#@export var shadow_image: Texture

@export var cloud_image: Texture
@export var shadow_image: Texture
@export var initial_rotation_degrees = 25
@export var scale_variance = 0.0
@export var cloud_speed = 200.0



var random_rot_speed = (randf() - 0.5) * 0.4

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Cloud.texture = cloud_image
	$Shadow.texture = shadow_image
	var children = [$Cloud, $Shadow]
	for child in children:
		child.rotation_degrees = initial_rotation_degrees
		child.scale.x = 4 + randf() * scale_variance
		child.scale.y = 4 + randf() * scale_variance

	
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Move myself:
	var speed_coefficient = 0.6
	position.x += delta * speed_coefficient * cloud_speed
	position.y -= delta * speed_coefficient * cloud_speed / 2
	if position.x > 5000:
		position.x = -8500
		position.y = randf() * 25000 - 15000
		
	if position.y < -2000:
		position.y = 4800
		position.x = randf() * 10000 - 7500
			
	var children = [$Cloud, $Shadow]
	for child in children:
		child.rotation += delta * random_rot_speed
		
		
		 
			
