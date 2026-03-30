extends StaticBody3D

@onready var enemy_detect : Node3D = $EnemyDetect

## Different for each turret, set on initialization of the turret
@export var detect_radius : float = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
