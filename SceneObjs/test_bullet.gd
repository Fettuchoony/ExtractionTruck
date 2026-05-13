extends StaticBody3D


var _target_pos : Vector3
var _dmg_area : Area3D
var _total_time = 0.25
var _time_left : float
var _peak_height : float
var _spawn_pos : Vector3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_dmg_area = $DamageArea
	_time_left = _total_time
	# TODO: calculate this
	_peak_height = 1
	print("spawned")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	_dmg_calc()
	_trajectory_calc()
	_time_left -= delta
	if _time_left < 0: queue_free()
	
	
func _dmg_calc() -> void:
	if _dmg_area.has_overlapping_bodies():
		for col in _dmg_area.get_overlapping_bodies():
			col.recieve_dmg(1)
			print(col.health)
		queue_free()

func _trajectory_calc() -> void:
	if _target_pos != null:
		var xDiff = _target_pos.x - _spawn_pos.x
		var yDiff = _target_pos.y - _spawn_pos.y
		var zDiff = _target_pos.z - _spawn_pos.z
		var turret_y_offset = _spawn_pos.y
		var a = turret_y_offset / _total_time
		# This is the inverse of time_left_ratio and height, compensates for height difference
		var height_comp = 0.5 * _total_time - (0.0714286 * sqrt(49 * pow(a,2) * pow(_total_time,2) + 20 * a * turret_y_offset) / a)
		#var turret_height_comp = 
		var t = _total_time - (_time_left / _total_time)
		# Based off formula -9.8 * t * (t - intercept_derived_from_inverse), which is a factored polynomial
		global_position.y = a * -9.8 * t * (t - _total_time - height_comp) + 1
		# interpolate cardinal plane movement from turret to target
		global_position.x = _spawn_pos.x + t * xDiff
		global_position.z = _spawn_pos.z + t * zDiff
		print(str(abs(t)) + " : " + str(height_comp))
		
