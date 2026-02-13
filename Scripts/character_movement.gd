extends CharacterBody3D


const MAX_SPEED = 3.5
const JUMP_SPEED = 6.5
const ACCELERATION = 4
const DECELERATION = 4
const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const INTERACT_COOLDOWN_TIME = 1

signal transfer_cam_to_vehicle(target:VehicleBody3D)
signal transfer_cam_to_player()
signal vehicle_entered(player:CharacterBody3D)
signal vehicle_exited()
signal pause_menu()

@onready var _camera = $CameraPivot/SpringArm3D/Camera3D
@onready var _target = $CameraPivot/SpringArm3D/Camera3D/PlayerRay
@onready var _debug_ball = $CameraPivot/SpringArm3D/Camera3D/PlayerRay/DebugBall
@onready var _can_enter_vehicle:bool = false
@onready var _in_vehicle:bool = false
@onready var _mouse_mode:int = 2
# Vehicle entrance should be the only collision option on layer 9
@onready var _vehicle_info = null
@onready var _enter_vehicle_cooldown:float = 0
# TODO: Create item list/map of all names, items ID by exact string (lowercase)
@onready var _items_equipped : Dictionary[String, bool]
@onready var _GUI_arr : Array[Node]
@export var debug:bool = false



func _physics_process(delta: float) -> void:
	_enter_vehicle_cooldown += delta
	handle_pausing()
	enter_vehicle()
	exit_vehicle()
	_GUI_arr = $GUI.get_children()
	if !_in_vehicle:
		movement_processing(delta)
	debug_aim()

# Displays UI for entering vehicle and handles user input and controller handover to vehicle script
func enter_vehicle() -> void:
	# TODO: UI implementation "Press F to enter vehicle"
	
	# Handles user input for transfering controls over to vehicle mode
	if _can_enter_vehicle and Input.is_action_just_pressed("Interact") and !_in_vehicle and _enter_vehicle_cooldown > INTERACT_COOLDOWN_TIME:
		print_debug("Player controller side camera transfer initiated")
		_enter_vehicle_cooldown = 0
		_in_vehicle = true
		vehicle_entered.emit(self)
		transfer_cam_to_vehicle.emit(_vehicle_info)
		
func exit_vehicle() -> void:
	if _in_vehicle and Input.is_action_just_pressed("Interact") and _enter_vehicle_cooldown > INTERACT_COOLDOWN_TIME:
		_enter_vehicle_cooldown = 0
		_in_vehicle = false
		vehicle_exited.emit()
		transfer_cam_to_player.emit(self)
		

# Handles user input and player direction / cardinal movement/jumping
func movement_processing(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.aaada
	# As good practice, you should replace UI actions with custom gameplay actions.
	var cam_right = Vector3.RIGHT
	var cam_back = Vector3.BACK
	var input_dir := Input.get_vector("Left", "Right", "Up", "Down")
	#var direction := (transform.basis * Vector3(input_dir.x * (cam_left + cam_right).x, 0, input_dir.y * (cam_front + cam_back).z)).normalized()
	var direction := (transform.basis * (input_dir.x) * Vector3(cam_right)).normalized()
	direction += (transform.basis * (input_dir.y) * Vector3(cam_back)).normalized()

	var hvel = velocity
	hvel.y = 0

	var target = direction * MAX_SPEED
	var acceleration
	if direction.dot(hvel) > 0:
		acceleration = ACCELERATION
	else:
		acceleration = DECELERATION

	hvel = hvel.lerp(target, acceleration * delta)

	# Assign hvel's values back to velocity, and then move.
	velocity.x = hvel.x
	velocity.z = hvel.z

	# Non-acceleration based controls:
	#if direction:
		#
		#velocity.x = direction.x * SPEED
		#velocity.z = direction.z * SPEED
#
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
		#velocity.z = move_toward(velocity.z, 0, SPEED)
		#
	move_and_slide()
	
func handle_pausing() -> void:
	# Pausing Functionality / Free mouse
	if Input.is_action_just_pressed("Escape"):
		if _mouse_mode == Input.MOUSE_MODE_CAPTURED:
			_mouse_mode = Input.MOUSE_MODE_VISIBLE
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			pause_menu.emit()
		else:
			_mouse_mode = Input.MOUSE_MODE_CAPTURED
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			pause_menu.emit()
			
func debug_aim() -> Node3D:
	if !debug:
		_debug_ball.visible = false
	else:
		_debug_ball.visible = true
		var target_point = _target.get_collision_point()
		_debug_ball.global_position = target_point
		print_debug(_target.get_collider())
	return


func _on_character_area_detect_area_entered(area: Area3D) -> void:
	var vehicle = area.get_parent()
	if vehicle != null and vehicle is VehicleBody3D:
		print("vehicle detected | id:" + vehicle.to_string())
		_vehicle_info = vehicle
		_can_enter_vehicle = true
	else:
		print_debug("Error: Cannot grab vehicle info despite colliding with entrance")


func _on_character_area_detect_area_exited(area: Area3D) -> void:
	_vehicle_info = null
	_can_enter_vehicle = false


func _on_menus_gui_input(event: InputEvent) -> void:
	print_debug(event)

# GUI Index 0: Q
# GUI Index 1: E
# GUI Index 2: R
func _bind_item(target: TextureRect, slot_num : int) -> void:
	# Make sure our references are not lost
	if _GUI_arr != null and target != null:
		# Texture inventory slot
		_GUI_arr[slot_num].texture = target.texture
		# Set texture filter to nearest to avoid blur
		_GUI_arr[slot_num].set_texture_filter(1)
