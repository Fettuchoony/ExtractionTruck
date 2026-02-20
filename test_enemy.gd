# https://docs.godotengine.org/en/4.6/tutorials/navigation/navigation_using_navigationagents.html
extends RigidBody3D

static var REFRESH_FREQUENCY : float = 1
static var HOP_FREQUENCY : float = 8
static var HOP_INTENSITY : float = 2
static var HEALTH_SHOW_TIME : float = 3

@export var movement_speed: float = 4.0

@onready var time : float = 0
@onready var health : int = 10
@onready var health_sprite : Sprite3D = $Sprite3D
@onready var health_sprite_timer : float = 0
@onready var heart_module_scene = preload("res://SceneObjs/heart_module.tscn")
@onready var health_bar : HBoxContainer = $"Sprite3D/EnemyViewport/Health Bar/HBoxContainer"
@onready var time_since_target_update : float = 0
@onready var time_since_last_hop : float = 0
@onready var player : CharacterBody3D = $"../../../MainPlayer"
@onready var player_cam : Camera3D = $"../../../MainPlayer/CameraPivot/SpringArm3D/Camera3D"
@onready var navigation_agent: NavigationAgent3D = get_node("NavigationAgent3D")

func _ready() -> void:
	navigation_agent.velocity_computed.connect(Callable(_on_velocity_computed))
	var i : int = 0
	while i < health:
		var heart = heart_module_scene.instantiate()
		health_bar.add_child(heart)
		i += 2

func _process(delta: float) -> void:
	pass

func set_movement_target(movement_target: Vector3):
	navigation_agent.set_target_position(movement_target)

func _physics_process(delta: float) -> void:
	_adjust_target()
	if health_sprite_timer > HEALTH_SHOW_TIME:
		health_sprite.visible = false
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
		time_since_target_update = 0
		set_movement_target(player._ground_pos)

func enable_info() -> void:
	health_sprite.visible = true
	health_sprite_timer = 0
