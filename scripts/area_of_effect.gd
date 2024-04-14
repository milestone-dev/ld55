extends Node2D
class_name AreaOfEffect

@export var spell : Spell
@export var collider: CollisionObject2D

func _ready():
	if collider:
		collider.body_shape_entered.connect(_on_body_enter)

func _on_body_enter(body):
	print("hit ", body)
