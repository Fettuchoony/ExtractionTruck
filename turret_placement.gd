extends Node3D

var placement_ray : RayCast3D

@onready var turret : StaticBody3D

@export var placement_range : float = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	placement_ray = $"../MainPlayer/CameraPivot/SpringArm3D/Camera3D/PlacementRay"
	placement_ray.target_position = Vector3(0, 0, -placement_range)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func prepare_turret(name: String) -> void:
	turret = load(name + ".tscn").instantiate()
	

func place_turret() -> void:
	if turret != null:
		turret.global_position = placement_ray.get_collision_point()
	
	 
