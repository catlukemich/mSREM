@icon("res://icons/tile.png")

extends TileMapLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var mouse_pos = get_global_mouse_position()
	print(mouse_pos)
	var cells = get_used_cells()
	for cell in cells:
		var cell_local_pos = map_to_local(cell)
		var cell_global_pos = to_global(cell_local_pos)
		var dist = cell_global_pos.distance_to(mouse_pos)
		if dist < 10:
			set_cell(cell)
			#var data : TileData = get_cell_tile_data(cell)
			#data.modulate = Color(1,1,1, 0.2)
			
		
	pass
