extends Control

@onready var _item_slots : Control = $TabContainer/Inventory
@onready var _item_slot_array : Array[TextureRect]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Create array of all children (items)
	_item_slots.get_children()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Player Controller sends a signal to toggle visibility
# Player controller handles mouse unlocking 
func _on_main_player_pause_menu() -> void:
	if visible:
		visible = false
	else:
		visible = true

# Removes hovering sprite


# Displays hovering sprite
func _on_item_slot_mouse_entered(source: Control) -> void:
	# Grab hover sprite
	var hover : TextureRect = source.get_child(0)
	hover.visible = true
	


func _on_item_slot_mouse_exited(source: Control) -> void:
	var hover : TextureRect = source.get_child(0)
	hover.visible = false

# Equip handler
func _on_item_slot_gui_input(event: InputEvent, source: Control) -> void:
	var equip : TextureRect = source.get_child(1)
	if event.is_action_pressed("Click"):
		if source.equipped:
			equip.visible = false
			source.equipped = false
		else:
			equip.visible = true
			source.equipped = true
