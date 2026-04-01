#extends RigidBody3D
#
## This is to make the explosion a child of the global scene and be able to delete the bomb
#
#@onready var main : Node3D = $".."
#@onready var age: float = 0
#@onready var wall_delete_hitbox : Area3D = $WallDeleteBox
#@onready var damage_hitbox : Area3D = $DamageBox
#@onready var explosion_fog  = preload("res://SceneObjs/explosion_bomb.tscn")
#@export var lifetime : float = 3
#@export var knockback_strength : float = 1
#
#
## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#add_constant_force(Vector3(0, 10, 10))
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _physics_process(delta: float) -> void:
	#print(global_position)
	#age += delta
	## Blow up
	#if age > lifetime:
		#explode()
#
#func explode() -> void:
	## Check for bombable walls (layer 11)
	#var wall_collisions : Array[Node3D] = wall_delete_hitbox.get_overlapping_bodies()
	#for col in wall_collisions:
		#col.queue_free()
	## Check for entitys to damage (layer 10)
	#var dmg_collisions : Array[Node3D] = damage_hitbox.get_overlapping_bodies()
	#for col in dmg_collisions:
		## Damage
		## TODO: emit damage signal to entity
		#
		#
		## Knockback
		## Scale knockback relevant to how close the bomb is
		#var distance : float = col.position.distance_to(position)
		#var knockback_scalar : float = knockback_strength / (distance + 0.01)
		#var knockback_dir : Vector3 = position.direction_to(col.position)
		#if knockback_dir.y > 0.1:
			#knockback_dir.y = 0.1
		## Give it some upward velocity
		#col.velocity += knockback_scalar * knockback_dir
	##var explosion = explosion_fog.instantiate()
	##explosion.position = position
	##main.add_child(explosion)
	## Delete the bomb
	#queue_free()
