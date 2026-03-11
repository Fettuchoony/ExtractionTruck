# This script should be the parent of all loading zones and initialize them.
extends StaticBody3D

# TODO: KEEP THIS UPDATED WITH ADDED LEVELS
## Controls where the loading zone points.[br]
## Scene Index:[br]
## 0: Main test scene[br]
## 1: First level test[br]
@onready var id_to_path : Dictionary = {
	0 : "res://Main.tscn",
	1 : "res://SceneObjs/test_level.tscn"
	}

@onready var loading_zone = $LoadingZone
@onready var spawn_point = $SpawnPoint

## The id for the scene, remember to set subscene
@export var scene_target : int = 0
## The subcene id in the target scene, will through error if out of bounds
@export var subscene_target : int = 0
## The subscene of THIS loader, controls where player spawns in
@export var subscene : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Connect loading zone area signal to this loading portal
	if loading_zone.has_signal("area_entered"):
		loading_zone.area_entered.connect(_on_loading_zone_area_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_loading_zone_area_entered(area: Area3D) -> void:
	print("loading entered")
	var cols = area.get_overlapping_areas()
	if cols != null and cols.size() > 0:
		# Set the players subscene to the target, overides old subscene
		cols[0].get_parent()._last_subscene = subscene_target
		# Moves scene to new scene
		get_tree().change_scene_to_file(id_to_path[scene_target])
