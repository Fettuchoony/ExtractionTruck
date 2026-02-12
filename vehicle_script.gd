extends Camera3D


# TODO: make sensitivity adjustable
@onready var _camera_pivot := $"../.." as Node3D
@export_range(0.0, 1.0) var mouse_sensitivity = 0.01
@export var tilt_limit = deg_to_rad(75)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		# Camera tilt, max tilt set above as global
		_camera_pivot.rotation.x -= event.relative.y * mouse_sensitivity
		# Clamps tilt within params
		_camera_pivot.rotation.x = clampf(_camera_pivot.rotation.x, -tilt_limit, tilt_limit)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
