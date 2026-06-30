class_name ProjectileModifier extends Item
# Modifies properties of projectiles, projectile is determined by the turret's Projectile augment


var _quality : float = 1.0
var quality_name : String = "Common"

@onready var _quality_rects = $Qualities.get_children()

# Deltas: changes to the given projectile
# Additive modifiers
@export var delta_dmg : int = 0
@export var delta_firerate : float = 0.0

@export_category("Quality Strengths (Base * Mult)")
@export var common_quality_mult : float = 1.0
@export var uncommon_quality_mult : float = 1.2
@export var rare_quality_mult : float = 1.4
@export var very_rare_quality_mult : float = 1.6
@export var legendary_quality_mult : float = 1.8
@export var mythic_quality_mult : float = 2.0

@export_category("Quality Bounds (0.0 - 1.0)")
@export var common_quality_cutoff : float = 0.5
@export var uncommon_quality_cutoff : float = 0.5
@export var rare_quality_cutoff : float = 0.7
@export var very_rare_quality_cutoff : float = 0.85
@export var legendary_quality_cutoff : float = 0.95
@export var mythic_quality_cutoff : float = 1.0

# Multiplicative modifiers



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	roll_quality()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super(delta)

# Takes a projectile and adds its deltas
func modify_proj(proj : ProjectileSpawner):
	proj.added_dmg += _quality * delta_dmg
	proj.added_firerate += _quality * delta_firerate

# TODO: as the game progresses, the chance to get higher rolls goes up so the player does not get god gear at the start of the game
func roll_quality() -> void:
	# reset
	for qual in _quality_rects: 
		qual.visible = false
	var roll : float = randf()
	if roll <= common_quality_cutoff:
		_quality = common_quality_mult
		quality_name = "Common (" + str(common_quality_mult) + ")"
		
	elif roll <= uncommon_quality_cutoff:
		_quality = uncommon_quality_mult
		quality_name = "Uncommon" + str(uncommon_quality_mult) + ")"
		_quality_rects[1].visible = true
		
	elif roll <= rare_quality_cutoff:
		_quality = rare_quality_mult
		quality_name = "Rare" + str(rare_quality_mult) + ")"
		_quality_rects[2].visible = true
		
	elif roll <= very_rare_quality_cutoff:
		_quality = very_rare_quality_mult
		quality_name = "Very Rare" + str(very_rare_quality_mult) + ")"
		_quality_rects[3].visible = true
		
	elif roll <= legendary_quality_cutoff:
		_quality = legendary_quality_mult
		quality_name = "Legendary" + str(legendary_quality_mult) + ")"
		_quality_rects[4].visible = true
		
	else:
		_quality = mythic_quality_mult
		quality_name = "Mythic" + str(mythic_quality_mult) + ")"
		_quality_rects[5].visible = true
