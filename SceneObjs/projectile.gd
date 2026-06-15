class_name Projectile extends Augment
# Determines the projectile of the turret, TODO: only one allowed?

# Deltas: determines the stat changes to the turret projectile(s)
@export var base_dmg : int = 0
@export var base_firerate : float = 0.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super(delta)
