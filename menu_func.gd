extends Control

# Editor order must be correct!
static var HOVER_SPRITE : int = 0
static var EQUIP_SPRITE : int = 1
static var QSLOT : int = 0
static var ESLOT : int = 1
static var RSLOT : int = 2

# Slot index indicated above statically
signal bind_item(target : TextureRect, slot_index : int)

@onready var _item_slots : Control = $TabContainer/Inventory
@onready var _item_slot_array : Array[TextureRect]
@onready var awaiting_assignment : bool = false
@onready var current_focus_item : TextureRect

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
	var hover : TextureRect = source.get_child(HOVER_SPRITE)
	hover.visible = true
	


func _on_item_slot_mouse_exited(source: Control) -> void:
	var hover : TextureRect = source.get_child(HOVER_SPRITE)
	hover.visible = false

# Equip handler
func _on_item_slot_gui_input(event: InputEvent, source: Control) -> void:
	var equip : TextureRect = source.get_child(EQUIP_SPRITE)
	# Primary and passives
	if event.is_action_pressed("Click"):
		# Clear previous inputs
		awaiting_assignment = false
		if (current_focus_item != null):
			current_focus_item.control_prompt.visible = false
		current_focus_item = source
		# Unequip
		if source.equipped:
			# TODO : Emit signal to player control
			equip.visible = false
			source.equipped = false
		# Skip Equip prompt if it is a passive item
		elif source.is_passive:
			# TODO: Emit signal to player control
			equip.visible = true
			source.equipped = true
		# Equip prompt brought up if item needs assignment
		else:
			awaiting_assignment = true
			source.control_prompt.visible = true
			print_debug("Awaiting input at " + current_focus_item.to_string() + " ...")
	
# Check for assignment of item
# Send signal to inventory and character manager for assignment
func _unhandled_key_input(event: InputEvent) -> void:
	if awaiting_assignment:
		# Display Input options
		current_focus_item.control_prompt.visible = true
		# Pass item info to player controller and GUI update
		if event.is_action_pressed("EItem"):
			bind_item.emit(current_focus_item, ESLOT)
			awaiting_assignment = false
			current_focus_item.control_prompt.visible = false
		elif event.is_action_pressed("RItem"):
			bind_item.emit(current_focus_item, RSLOT)
			awaiting_assignment = false
			current_focus_item.control_prompt.visible = false
		elif event.is_action_pressed("QItem"):
			bind_item.emit(current_focus_item, QSLOT)
			awaiting_assignment = false
			current_focus_item.control_prompt.visible = false
		else:
			current_focus_item.control_prompt.visible = false
			current_focus_item = null
			awaiting_assignment = false
			
		
	# Bail on item assignment if incorrect input detected
	else:
		pass

func _on_grapple_gui_input(event: InputEvent, source: Control) -> void:
	pass # Replace with function body.
