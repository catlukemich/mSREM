@tool
extends Node

@export var btn_show_all_nodes: bool:
	set(v): reveal_hidden_objects()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func reveal_hidden_objects():
	for node in get_tree().get_root().get_children():
		_reveal_recursively(node)

func _reveal_recursively(node : EditorNode):
	if node.visible == false:
		node.visible = true
		print("Revealed:", node.name)
	for child in node.get_children():
		_reveal_recursively(child)
