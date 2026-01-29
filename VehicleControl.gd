extends VehicleBody3D

signal on_vehicle_entered
signal on_vehicle_exited

@onready var _vehicle_entered: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_vehicle_entered = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
# Signal called in player controller
func _on_vehicle_entered() -> void:
	_vehicle_entered = true

# Signal called in player controller
func _on_vehicle_exited() -> void:
	_vehicle_entered = false
