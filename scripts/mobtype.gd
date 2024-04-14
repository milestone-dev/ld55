extends Resource
class_name Mobtype

@export var max_hp = 100;
@export var speed = 1000;
@export var attack_damage = 5;
@export var attack_cooldown_max = 0.3;
@export var attack_range = 8;
@export var experience : int = 5;
@export var sprite: Texture2D
@export var color : Color = Color.WHITE;
@export var scale : float = 1;
@export var animation_speed : float = 1;
@export var mob_sfx : Array[AudioStream];

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

