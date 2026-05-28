extends Control

# The turret the GUI is representing
@onready var _turret : Node3D
@onready var _turret_name : Label = $TurretName
@onready var _dmg : Label = $VBoxContainer/Dmg
@onready var _fire_rate : Label = $VBoxContainer/FireRate

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func init(turret: Node3D) -> void:
	_turret = turret
	_turret_name.text = turret.COLLOQUIAL_NAME
	_dmg.text = "Damage: " + str(_turret.dmg)
	_fire_rate.text = "Fire Rate: " + str(_turret.firing_rate)
