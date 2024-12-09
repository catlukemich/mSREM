@tool

extends Node2D

var parts_filenames  = {'0016-0001': 'rails_x16y1.png', '0017-0001': 'rails_x17y1.png', '0018-0001': 'rails_x18y1.png', '0019-0001': 'rails_x19y1.png', '0020-0001': 'rails_x20y1.png', '0021-0001': 'rails_x21y1.png', '0022-0001': 'rails_x22y1.png', '0023-0001': 'rails_x23y1.png', '0024-0001': 'rails_x24y1.png', '0025-0001': 'rails_x25y1.png', '0026-0001': 'rails_x26y1.png', '0027-0001': 'rails_x27y1.png', '0028-0001': 'rails_x28y1.png', '0029-0001': 'rails_x29y1.png', '0030-0001': 'rails_x30y1.png', '0031-0001': 'rails_x31y1.png', '0032-0001': 'rails_x32y1.png', '0014-0002': 'rails_x14y2.png', '0015-0002': 'rails_x15y2.png', '0016-0002': 'rails_x16y2.png', '0017-0002': 'rails_x17y2.png', '0018-0002': 'rails_x18y2.png', '0019-0002': 'rails_x19y2.png', '0020-0002': 'rails_x20y2.png', '0021-0002': 'rails_x21y2.png', '0022-0002': 'rails_x22y2.png', '0023-0002': 'rails_x23y2.png', '0024-0002': 'rails_x24y2.png', '0025-0002': 'rails_x25y2.png', '0026-0002': 'rails_x26y2.png', '0027-0002': 'rails_x27y2.png', '0028-0002': 'rails_x28y2.png', '0029-0002': 'rails_x29y2.png', '0030-0002': 'rails_x30y2.png', '0031-0002': 'rails_x31y2.png', '0032-0002': 'rails_x32y2.png', '0011-0003': 'rails_x11y3.png', '0012-0003': 'rails_x12y3.png', '0013-0003': 'rails_x13y3.png', '0014-0003': 'rails_x14y3.png', '0009-0004': 'rails_x9y4.png', '0010-0004': 'rails_x10y4.png', '0011-0004': 'rails_x11y4.png', '0012-0004': 'rails_x12y4.png', '0000-0005': 'rails_x0y5.png', '0001-0005': 'rails_x1y5.png', '0002-0005': 'rails_x2y5.png', '0003-0005': 'rails_x3y5.png', '0004-0005': 'rails_x4y5.png', '0005-0005': 'rails_x5y5.png', '0006-0005': 'rails_x6y5.png', '0007-0005': 'rails_x7y5.png', '0008-0005': 'rails_x8y5.png', '0009-0005': 'rails_x9y5.png', '0010-0005': 'rails_x10y5.png'}
var catenary_filenames = {'0016-0001': 'catenary_foreground_x16y1.png', '0017-0001': 'catenary_foreground_x17y1.png', '0018-0001': 'catenary_foreground_x18y1.png', '0019-0001': 'catenary_foreground_x19y1.png', '0020-0001': 'catenary_foreground_x20y1.png', '0021-0001': 'catenary_foreground_x21y1.png', '0022-0001': 'catenary_foreground_x22y1.png', '0023-0001': 'catenary_foreground_x23y1.png', '0024-0001': 'catenary_foreground_x24y1.png', '0025-0001': 'catenary_foreground_x25y1.png', '0026-0001': 'catenary_foreground_x26y1.png', '0027-0001': 'catenary_foreground_x27y1.png', '0028-0001': 'catenary_foreground_x28y1.png', '0029-0001': 'catenary_foreground_x29y1.png', '0030-0001': 'catenary_foreground_x30y1.png', '0031-0001': 'catenary_foreground_x31y1.png', '0014-0002': 'catenary_foreground_x14y2.png', '0015-0002': 'catenary_foreground_x15y2.png', '0016-0002': 'catenary_foreground_x16y2.png', '0017-0002': 'catenary_foreground_x17y2.png', '0018-0002': 'catenary_foreground_x18y2.png', '0019-0002': 'catenary_foreground_x19y2.png', '0020-0002': 'catenary_foreground_x20y2.png', '0021-0002': 'catenary_foreground_x21y2.png', '0022-0002': 'catenary_foreground_x22y2.png', '0023-0002': 'catenary_foreground_x23y2.png', '0024-0002': 'catenary_foreground_x24y2.png', '0025-0002': 'catenary_foreground_x25y2.png', '0026-0002': 'catenary_foreground_x26y2.png', '0027-0002': 'catenary_foreground_x27y2.png', '0028-0002': 'catenary_foreground_x28y2.png', '0029-0002': 'catenary_foreground_x29y2.png', '0030-0002': 'catenary_foreground_x30y2.png', '0031-0002': 'catenary_foreground_x31y2.png', '0032-0002': 'catenary_foreground_x32y2.png', '0012-0003': 'catenary_foreground_x12y3.png', '0013-0003': 'catenary_foreground_x13y3.png', '0014-0003': 'catenary_foreground_x14y3.png', '0010-0004': 'catenary_foreground_x10y4.png', '0011-0004': 'catenary_foreground_x11y4.png', '0012-0004': 'catenary_foreground_x12y4.png', '0000-0005': 'catenary_foreground_x0y5.png', '0001-0005': 'catenary_foreground_x1y5.png', '0002-0005': 'catenary_foreground_x2y5.png', '0003-0005': 'catenary_foreground_x3y5.png', '0004-0005': 'catenary_foreground_x4y5.png', '0005-0005': 'catenary_foreground_x5y5.png', '0006-0005': 'catenary_foreground_x6y5.png', '0007-0005': 'catenary_foreground_x7y5.png', '0008-0005': 'catenary_foreground_x8y5.png', '0009-0005': 'catenary_foreground_x9y5.png', '0010-0005': 'catenary_foreground_x10y5.png'}
@export var btn_reimport_rails : bool:
	set(value):
		do_parts_import()
		

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	do_parts_import()
	pass # Replace with function body.

func do_parts_import():
	var dirs = {"res://assets/rails/rails/": parts_filenames, "res://assets/rails/catenary_foregrond/": catenary_filenames}
	for dir in dirs:
		var filenames = dirs[dir]
		for coords : String in filenames:
			var xy = coords.split("-")
			var x = int(xy[0])
			var y = int(xy[1])
			
			var filename = filenames[coords]
			#var rail_image = load("res://assets/rails/" + filename)
			var part_sprite = Sprite2D.new()
			add_child(part_sprite)
			print(x, y)
			
			var image = Image.load_from_file(dir + filename)
			var texture = ImageTexture.create_from_image(image)
			part_sprite.texture = texture
			var BLOCK_SIZE = 250
			part_sprite.position.x = x * BLOCK_SIZE
			part_sprite.position.y = y * BLOCK_SIZE
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
