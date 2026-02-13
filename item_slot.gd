extends TextureRect

@onready var equipped : bool
# Set by menu controller and nullified by player controller
@onready var equipped_on_slot_num : int
@onready var control_prompt : Control = $ControlPrompt
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
