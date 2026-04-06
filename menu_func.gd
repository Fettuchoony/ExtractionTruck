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
@onready var _player = $"../MainPlayer"
@onready var _current_hovered_item_name : String = ""
@onready var turret_scene = preload("res://SceneObjs/turret_placement.tscn")
@onready var placement_ray : RayCast3D = $"../MainPlayer/CameraPivot/SpringArm3D/Camera3D/PlacementRay"
@onready var _currently_idleing : bool = false
@onready var _current_idle_obj = null



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Create array of all children (items)
	_item_slots.get_children()
	init_taskbar()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_taskbar_scrolling()
	_execute_idles()

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
		if source.equipped:
			## TODO : Emit signal to player control
			equip.visible = false
			source.equipped = false
			#source.equipped_on_slot_num = -1
			_unbind_item.emit(current_focus_item)
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
	
# Check for assignment of item
# Send signal to inventory and character manager for assignment
func _unhandled_key_input(event: InputEvent) -> void:
	pass
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

# TODO: Find a way to make this use event instead of direct input?
func _taskbar_scrolling() -> void:
	if Input.is_action_just_released("ScrollDown"):
		print("scrolling down")
		_taskbar_rects[_current_taskbar_index].find_child("Equipped").visible = false
		_current_taskbar_index -= 1
		if _current_taskbar_index < 0:
			_current_taskbar_index = 8
		_taskbar_rects[_current_taskbar_index].find_child("Equipped").visible = true
		_currently_idleing = false
		
	if Input.is_action_just_released("ScrollUp"):
		print("scrolling up")
		_taskbar_rects[_current_taskbar_index].find_child("Equipped").visible = false
		_current_taskbar_index += 1
		if _current_taskbar_index > 8:
			_current_taskbar_index = 0
		_taskbar_rects[_current_taskbar_index].find_child("Equipped").visible = true
		_currently_idleing = false
	_current_hovered_item_name = _player._taskbar_items[_current_taskbar_index]

func _on_main_player_trigger_item_idle(item_name: String) -> void:
	pass # Replace with function body.

func _execute_idles() -> void:
	if _current_hovered_item_name.ends_with("turret"):
		if !_currently_idleing:
			var placement_location = placement_ray.get_collision_point()
			_current_idle_obj = turret_scene.instantiate()
			_current_idle_obj.position = placement_location
			# Find current level to place turret
			var curr_level = get_tree().get_nodes_in_group("levels")
			if curr_level == null:
				print("Cannot find current level for turret placement")
			else:
				curr_level = curr_level[0]
			# This way, turrets are saved on changing level
			curr_level.add_child(_current_idle_obj)
			_currently_idleing = true
	elif (_current_idle_obj != null && _current_idle_obj.place_mode == true):
		_current_idle_obj.free()

func init_taskbar() -> void:
	_taskbar_rects[_current_taskbar_index].find_child("Equipped").visible = true
