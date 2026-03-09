extends Area3D

# TODO: KEEP THIS UPDATED WITH ADDED LEVELS
## Controls where the loading zone points.[br]
## Scene Index:[br]
## 0: Main test scene[br]
## 1: First level test[br]
@export var scene_target_index : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var cols = get_overlapping_areas()
	if cols != null and cols.size() > 0:
		get_tree().change_scene_to_file("res://SceneObjs/test_level.tscn")
		
