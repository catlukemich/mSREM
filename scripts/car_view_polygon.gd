extends CollisionPolygon2D


@export var view_distance : float = 1 # View distance in game world units
	
@export var view_angle : float = 45 # View angle in degrees
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	polygon = PackedVector2Array([Vector2(), Vector2(), Vector2()])
	recreate_self()
	

func recreate_self(rotation_angle : float = 0):
	# X is W-E
	# Y is N-S
	# Z is DOWN-UP
	var verts_locations = [
		Vector3(0, -0.25, 0), # Car origin
		Vector3(0, -1, 0), # Left side
		Vector3(0, -1, 0), # Right side
	]
	
	for i in range(len(verts_locations)):
		verts_locations[i] = verts_locations[i].rotated(Vector3(0,0,1), deg_to_rad(rotation_angle))
		pass
	
	
	verts_locations[1] = verts_locations[1] \
		.rotated(Vector3(0,0,1), deg_to_rad(view_angle / 2)) \
		* view_distance
	verts_locations[2] = verts_locations[2] \
		.rotated(Vector3(0,0,1), - deg_to_rad(view_angle / 2)  ) \
		* view_distance
		
	var verts_positions = []
	verts_positions.resize(3)
	var i = 0
	
	polygon.clear()
	for location in verts_locations:
		var vert_position = Globals.project(location)
		#verts_positions[i] = vert_position
		polygon.append(vert_position)
		polygon[i] = vert_position
		#print(polygon[i])
		#print(vert_position)
		
		i += 1
	
	#polygon = PackedVector2Array(verts_positions)
	
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#
func _on_car_direction_changed_signal(direction: int, rotation_degrees: float) -> void:
	recreate_self(rotation_degrees)
	#print(rotation_degrees)
	#pass # Replace with function body.
