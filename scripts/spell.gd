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
@export var store_texture : Texture;
@export var code : String;
@export var damage : float = 10;
@export var range : float = 32;
@export var heal : float = 0;
@export var effect: PackedScene

@export var projectile_texture : Texture2D

@export var effect_duration : float = 0;
@export var effect_cooldown_max : float = 0;

@export var projectile_behavior : SpellProjectileBehavior;
@export var effect_area_behavior : SpellEffectAreaBehavior;


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func validate_code(input_code: String) -> bool:
	return input_code.replace(",","") == code.replace(",","");
