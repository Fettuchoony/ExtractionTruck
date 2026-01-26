extends CharacterBody3D


const MAX_SPEED = 3.5
const JUMP_SPEED = 6.5
const ACCELERATION = 4
const DECELERATION = 4
const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@onready var _camera = $CameraPivot/SpringArm3D/Camera3D
@onready var _target = $CameraPivot/SpringArm3D/Camera3D/PlayerRay
@onready var _debug_ball = $CameraPivot/SpringArm3D/Camera3D/PlayerRay/DebugBall
@onready var _mouse_mode:int = 2

@export var debug:bool = false



func _physics_process(delta: float) -> void:
	movement_processing(delta)
	debug_aim()
	


# Handles user input and player direction / cardinal movement/jumping
func movement_processing(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Pausing Functionality
	if Input.is_action_just_pressed("Escape"):
		if _mouse_mode == Input.MOUSE_MODE_CAPTURED:
			_mouse_mode = Input.MOUSE_MODE_VISIBLE
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			_mouse_mode = Input.MOUSE_MODE_CAPTURED
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		

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
	
func debug_aim() -> Node3D:
	if !debug:
		_debug_ball.visible = false
	else:
		_debug_ball.visible = true
		var target_point = _target.get_collision_point()
		_debug_ball.global_position = target_point
		print_debug(_target.get_collider())
	return
