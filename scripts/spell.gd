extends Resource
class_name Spell

enum SpellProjectileBehavior {
	NONE,
	ADD_TIMED,
	REPLACE_TIMED,
	SINGLE_FIRE,
}

enum SpellEffectAreaBehavior {
	NONE,
	TIMED,
	SINGLE_FIRE,
}

@export var name : String = "Unnamed spell";
@export var code : String;
@export var description : String = "";
@export var dependency : Spell
@export var weight : float = 1;
@export var store_texture : Texture;
@export var store_icon : Texture;
@export var spell_guide : Texture;

@export_category("Projectile")
@export var projectile_scene: PackedScene
@export var projectile_behavior : SpellProjectileBehavior;
@export var projectile_max_hits: int = 1;
@export_category("Effect")
@export var area_of_effect_scene: PackedScene
@export var area_of_effect_on_player : = true;
@export var effect_area_behavior : SpellEffectAreaBehavior;
@export var effect_duration : float = 1;
@export var effect_cooldown_max : float = 0.3;
@export var speed_multiplier: float = 0
@export var heal : float = 0;
@export_category("Damage")
@export var damage_over_time: float = 0 #duration of the dot.
@export var attack_damage : float = 10;
@export var attack_range : float = 32;




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func validate_code(input_code: String) -> bool:
	return input_code.replace(",","") == code.replace(",","");
