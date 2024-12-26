extends Node

var TILE_WIDTH = 256
var TILE_HEIGHT = 128
var V_STEP = 313

func fuck():
	print("fucking")

func project(location : Vector3) -> Vector2:
	var htw = TILE_WIDTH / 2 # The original half tile width.
	var hth = TILE_HEIGHT / 2 # and half tile height
	var v_step = V_STEP # and vertical step

	var x = (location.x - location.y) * htw
	var y = (location.x + location.y) * hth - (location.z) * v_step
   
	return Vector2(x,y)
	
