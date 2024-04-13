extends CharacterBody2D


@export var max_hp = 100;
var hp = max_hp;

func _physics_process(delta):
	pass

func die():
	queue_free()
