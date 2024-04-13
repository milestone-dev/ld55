extends CharacterBody2D


const SPEED = 30000.0

func _physics_process(delta):

	velocity.x = Input.get_axis("ui_left", "ui_right")
	velocity.y = Input.get_axis("ui_up", "ui_down")
	velocity = velocity.normalized() *  SPEED * delta;

	move_and_slide()
