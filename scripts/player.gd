extends CharacterBody2D
class_name Player

@export var max_speed = 30000;
@export var camera : Camera2D;

func _physics_process(delta):

	velocity.x = Input.get_axis("move_left", "move_right")
	velocity.y = Input.get_axis("move_up", "move_down")
	velocity = velocity.normalized() *  max_speed * delta;

	move_and_slide()

func _on_damage_area_body_entered(body):
	if not body is Mob: return;
	
	print ("hit")
