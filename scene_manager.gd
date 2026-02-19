extends Node3D

static var OUT_OF_BOUNDS : Vector3 = Vector3(99999, 99999, 99999)

@onready var explosion_preload = preload("res://SceneObjs/explosion_bomb.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	preload_explosion()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Forces a render of the explosion at the start of the scene to prevent lag spike on first bomb instance
func preload_explosion() -> void:
	var explode = explosion_preload.instantiate()
	explode.position = OUT_OF_BOUNDS
