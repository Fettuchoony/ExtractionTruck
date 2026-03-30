extends Control


# Slot index indicated above statically
signal bind_item(target : TextureRect, slot_index : int)

# Unequip signal to player controller
signal _unbind_item(target: TextureRect)

@onready var _item_slots : Control = $TabContainer/Inventory
@onready var _current_taskbar_index : int = 0
@onready var current_focus_item : TextureRect
@onready var _taskbar_rects = $"../MainPlayer/GUI/TaskBar/HBoxContainer".get_children()
@onready var _equip_texture = preload("res://SceneObjs/equipped.tscn")



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

# Equip handler
func _on_item_slot_gui_input(event: InputEvent, source: Control) -> void:
	var equip : TextureRect = source.find_child("Equipped")
	# Primary and passives
	if event.is_action_pressed("Click"):
		# Reassign curr item
		current_focus_item = source
		# Unequip
		#if source.equipped:
			## TODO : Emit signal to player control
			#awaiting_assignment = false
			#source.control_prompt.visible = false
			#equip.visible = false
			#source.equipped = false
			##source.equipped_on_slot_num = -1
			#_unbind_item.emit(current_focus_item)
		# Skip Equip prompt if it is a passive item
		if source.is_passive:

			equip.visible = true
			source.equipped = true
			bind_item.emit(current_focus_item, -1)
		# Equip prompt brought up if item needs assignment
		else:
			equip.visible = true
			source.equipped = true
			bind_item.emit(current_focus_item, _current_taskbar_index)
			print_debug("Awaiting input at " + current_focus_item.to_string() + " ...")
	
# Check for assignment of item
# Send signal to inventory and character manager for assignment
func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("ScrollDown"):
		print("scrolling down")
		_taskbar_rects[_current_taskbar_index].find_child("equipped").free()
		_current_taskbar_index -= 1
		if _current_taskbar_index < 0:
			_current_taskbar_index = 8
		_taskbar_rects[_current_taskbar_index].add_child(_equip_texture.instantiate())
		
	if event.is_action_pressed("ScrollUp"):
		print("scrolling up")
		_taskbar_rects[_current_taskbar_index].find_child("equipped").free()
		_current_taskbar_index += 1
		if _current_taskbar_index > 8:
			_current_taskbar_index = 0
		_taskbar_rects[_current_taskbar_index].add_child(_equip_texture.instantiate())
	#if awaiting_assignment:
		## Display Input options
		#current_focus_item.control_prompt.visible = true
		## Pass item info to player controller and GUI update
		#if event.is_action_pressed("EItem"):
			#bind_item.emit(current_focus_item, ESLOT)
			#awaiting_assignment = false
			#current_focus_item.equipped = true
			#if current_focus_item.get_child(1) != null:
				#current_focus_item.get_child(1).visible = true
			#current_focus_item.control_prompt.visible = false
		#elif event.is_action_pressed("RItem"):
			#bind_item.emit(current_focus_item, RSLOT)
			#awaiting_assignment = false
			#current_focus_item.equipped = true
			#if current_focus_item.get_child(1) != null:
				#current_focus_item.get_child(1).visible = true
			#current_focus_item.control_prompt.visible = false
		#elif event.is_action_pressed("QItem"):
			#bind_item.emit(current_focus_item, QSLOT)
			#awaiting_assignment = false
			#current_focus_item.equipped = true
			#if current_focus_item.get_child(1) != null:
				#current_focus_item.get_child(1).visible = true
			#current_focus_item.control_prompt.visible = false
		#else:
			#print("unassign")
			#current_focus_item.control_prompt.visible = false
			#current_focus_item = null
			#awaiting_assignment = false
	
		
	# Bail on item assignment if incorrect input detected
	#else:
		#pass
	pass
