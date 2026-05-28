extends RigidBody3D

@export var hold_strength : float = 1
@export var dampen_factor : float = 1

@onready var being_held : bool = false
@onready var hold_pos : Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func _physics_process(_delta: float) -> void:
	if being_held:
		gravity_scale = 0
		linear_velocity = hold_strength * global_position.distance_to(hold_pos.global_position) * global_position.direction_to(hold_pos.global_position)
	else:
		gravity_scale = 1
	
