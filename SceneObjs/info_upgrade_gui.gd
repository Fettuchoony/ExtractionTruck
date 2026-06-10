extends Control
class_name TurretUpgrades

@onready var _perk_slots : Array[Node] = $UpgradeMatrix.get_children()

# The turret the GUI is representing
var _turret : Node3D

var _turret_name : Label 
var _dmg : Label
var _fire_rate : Label
var _player : CharacterBody3D
var _menu : Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_turret_name = $TurretName
	_dmg = $Panel/VBoxContainer/Dmg
	_fire_rate = $Panel/VBoxContainer/FireRate
	_player = get_parent().get_parent().find_child("MainPlayer")
	_menu = get_parent()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_menu = get_parent()
	if _menu != null:
		# Check for added perks
		for slot in _perk_slots:
			var slot_augment_spot = slot.find_child("Augment")
			var slot_rect = slot.get_rect()
			slot_rect.position = slot.global_position
			var cursor_item = _menu._cursor_item
			# Hovering func
			if slot_rect.has_point(get_screen_transform() * get_local_mouse_position()):
				slot.find_child("Hover").visible = true
			else: 
				slot.find_child("Hover").visible = false
			var already_toggled : bool = false
			
			# Assignment func
			# If: clicked, within slot rect, cursor is holding an item, and the item is an augment:
			if Input.is_action_just_pressed("Click") and slot_rect.has_point(get_screen_transform() * get_local_mouse_position()) && cursor_item.get_child_count() != 0 && cursor_item.get_child(0) is Augment:
				print_debug("Adding augment: " + cursor_item.get_child(0).name + " to " + _turret_name.text)
				cursor_item.get_child(0).global_position = slot.global_position
				cursor_item.get_child(0).reparent(slot_augment_spot)
				already_toggled = true
			
			# If the slot is clicked but there is no cursor item:
			if !already_toggled && Input.is_action_just_pressed("Click") and slot_rect.has_point(get_screen_transform() * get_local_mouse_position()) && cursor_item.get_child_count() == 0 && slot_augment_spot.get_child_count() != 0:
				# Add the item back to the inventory
				_player._pickup_item(slot_augment_spot.get_child(0))
				# Attach to cursor
				slot_augment_spot.get_child(0).reparent(cursor_item)
			

# Modifies base stats with upgrades and updates display
func init(turret: Node3D) -> void:
	_turret = turret
	_turret_name.text = turret.COLLOQUIAL_NAME + str(int(Time.get_ticks_msec() / 1000.0))
	_dmg.text = "Damage: " + str(_turret.dmg)
	_fire_rate.text = "Fire Rate: " + str(_turret.firing_rate)
	
