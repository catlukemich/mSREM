@tool

@icon("res://icons/water.png")
extends Node2D
class_name Lake2D

@export var wind_direction: Vector2:
	set(value):
		wind_direction = value
		set_wind_direction(value)
	get:
		return wind_direction

@export_range(0.1, 100) var tile_scale = 1.0:
	set(value):
		tile_scale = value
		set_tile_scale(value)

@export_color_no_alpha var water_color_1: Color:
	set(value):
		water_color_1 = value
		set_water_color_1(value)

@export_color_no_alpha var water_color_2: Color:
	set(value):
		water_color_2 = value
		set_water_color_2(value)


@export_color_no_alpha var foam_color: Color:
	set(value):
		foam_color = value
		set_foam_color(value)



func set_tile_scale(scale):
	var shader := $LakeWater.material as ShaderMaterial
	shader.set_shader_parameter("tile_scale", scale)
	

func set_water_color_1(color):
	var shader := $LakeWater.material as ShaderMaterial
	shader.set_shader_parameter("WATER_COL", color)
	
func set_water_color_2(color):
	var shader := $LakeWater.material as ShaderMaterial
	shader.set_shader_parameter("WATER2_COL", color)

func set_foam_color(color):
	var shader := $LakeWater.material as ShaderMaterial
	shader.set_shader_parameter("FOAM_COL", color)

func set_wind_direction(direction: Vector2):
	var shader := $LakeWater.material as ShaderMaterial
	shader.set_shader_parameter("wind_dir", direction)



func _draw() -> void:
	var points = $LakeWater.input_path.curve.get_baked_points()
	points.append(points[0])
	for index in range(0, len(points) -1):
		var curr = points[index] + $LakeWater.position;
		var next = points[index + 1] + $LakeWater.position;
		draw_line(curr, next, Color.ORANGE, 6, true);
		
	
