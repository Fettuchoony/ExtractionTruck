extends VehicleBody3D

@onready var _vehicle_entered: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_vehicle_entered = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Called from player controller
func _on_main_player_vehicle_entered() -> void:
	pass # Replace with function body.

# Called from player controller
func _on_main_player_vehicle_exited() -> void:
	pass # Replace with function body.
