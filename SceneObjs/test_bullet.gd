extends RigidBody3D

@onready var target : Node3D = null
@onready var life : float = 1
@onready var time : float = 0
@onready var rawdist : float
@onready var dmg_area : Area3D = $DamageArea

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if dmg_area.has_overlapping_bodies():
		for col in dmg_area.get_overlapping_bodies():
			col.recieve_dmg(1)
			print(col.health)
		free()
	
	
