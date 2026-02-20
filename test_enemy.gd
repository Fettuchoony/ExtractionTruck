# https://docs.godotengine.org/en/4.6/tutorials/navigation/navigation_using_navigationagents.html
extends RigidBody3D

static var REFRESH_FREQUENCY : float = 1
static var HOP_FREQUENCY : float = 8
static var HOP_INTENSITY : float = 2

@onready var time : float = 0
@export var movement_speed: float = 4.0
@onready var time_since_target_update : float = 0
@onready var time_since_last_hop : float = 0
@onready var player : CharacterBody3D = $"../../../MainPlayer"
@onready var navigation_agent: NavigationAgent3D = get_node("NavigationAgent3D")

func _ready() -> void:
	navigation_agent.velocity_computed.connect(Callable(_on_velocity_computed))
	#set_movement_target(Vector3(100, -1, -100))

func set_movement_target(movement_target: Vector3):
	navigation_agent.set_target_position(movement_target)

func _physics_process(delta: float) -> void:
	_adjust_target()
	time_since_target_update += delta
	time_since_last_hop += delta
	# Do not query when the map has never synchronized and is empty.
	if NavigationServer3D.map_get_iteration_id(navigation_agent.get_navigation_map()) == 0:
		return
	if navigation_agent.is_navigation_finished():
		return
	var next_path_position: Vector3 = navigation_agent.get_next_path_position()
	var new_velocity: Vector3 = global_position.direction_to(next_path_position) * movement_speed
	# Hopping for slime
	new_velocity.x *= abs(sin(time))
	new_velocity.z *= abs(sin(time))
	new_velocity.y += HOP_INTENSITY * sin(HOP_FREQUENCY * time)
	if navigation_agent.avoidance_enabled:
		navigation_agent.set_velocity(new_velocity)
	else:
		_on_velocity_computed(new_velocity)
	time += delta

func _on_velocity_computed(safe_velocity: Vector3):
	linear_velocity = safe_velocity

func _adjust_target() -> void :
	if time_since_target_update > REFRESH_FREQUENCY:
		print(player._ground_pos)
		time_since_target_update = 0
		set_movement_target(player._ground_pos)
