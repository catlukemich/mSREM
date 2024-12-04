@tool
extends Polygon2D

@export var btn_bake : bool:
	set(value):
		rebake()

@export var input_path: Path2D:
	get(): 
		return input_path
	set(value): 
		input_path = value
		reconnect_to_polygon(value)
		bake(value)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if input_path == null:
		var path2d = Path2D.new()
		path2d.curve = Curve2D.new()
		input_path = path2d
		
	var points = input_path.curve.get_baked_points()
	polygon = PackedVector2Array(points)


func bake(entry_input_path) -> void:
	if entry_input_path == null: return
	var points = entry_input_path.curve.get_baked_points()
	polygon = PackedVector2Array(points)

func rebake() -> void:
	print("reabake")
	if input_path != null:
		bake(input_path)
	
func reconnect_to_polygon(input_path) -> void:
	if input_path == null: return
	if input_path.curve != null:
		input_path.curve.changed.connect(rebake)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
