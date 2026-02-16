extends TextureRect

@onready var equipped : bool
# Set by menu controller and nullified by player controller
@onready var equipped_on_slot_num : int
@onready var control_prompt : Control = $ControlPrompt
@onready var bomb_scene = preload("res://SceneObjs/bomb_item.tscn")
@export var is_passive : bool



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Connect signals for binds to the MenuController and PlayerController
	connect_signals()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func connect_signals() -> void:
	pass
	
# Needs to work for every item
func use_item(item_name: String, location: Node3D) -> void:
	#print_debug("Using: " + item_name)
	if(item_name == "grapple"):
		pass
	elif(item_name == "bomb"):
		exec_bomb(location)
	pass

func exec_bomb(location: Node3D) -> void:
	var bomb_instance = bomb_scene.instantiate()
	bomb_instance.position = location.global_position
	add_child(bomb_instance)
