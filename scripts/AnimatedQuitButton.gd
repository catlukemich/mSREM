extends OriginalAnimatedButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super(delta)
	


func _pressed():
	var tree := get_tree()
	if tree != null:
		tree.paused = false
		tree.root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
		tree.call_deferred("quit", 0)
