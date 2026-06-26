class_name HoverInfo extends Control

@onready var _panel


func _init(item : Item = null) -> void:
	if item != null:
		print(item.name)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if _panel != null:
		_panel.global_position = get_screen_transform() * get_local_mouse_position()
	else:
		_panel = find_child("Panel")
