extends Resource
class_name Spell

@export var name : String = "The spell with no name";
@export var code : String;
@export var damage : float = 10;
@export var range : float = 32;
@export var heal : float = 0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func validate_code(input_code: String) -> bool:
	prints(input_code, "vs", code)
	return input_code == code;
