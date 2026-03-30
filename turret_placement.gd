extends Node3D

enum Turret_Type {gunner}

var placement_ray : RayCast3D

@onready var turret : StaticBody3D

@export var placement_range : float = 10
@export var turret_type : Turret_Type = Turret_Type.gunner

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	placement_ray = $"../../MainPlayer".find_child("PlacementRay")
	if placement_ray == null:
		print("Could not find placement ray/position reference for getting position")
	placement_ray.target_position = Vector3(0, 0, -placement_range)
	var temp_turret = load("res://SceneObjs/" + Turret_Type.keys()[turret_type] + "_turret.tscn")
	turret = temp_turret.instantiate()
	add_child(turret)
	print("placed: " + turret.name)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var target_pos = placement_ray.get_collision_point()
	if turret != null:
		turret.global_position = target_pos
