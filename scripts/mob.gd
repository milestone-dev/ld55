extends CharacterBody2D
class_name Mob

@export var max_hp = 100;
@export var speed = 10000;
@export var damage = 20;

var hp = max_hp;

var player_target : Player;

func _ready():
	player_target = get_tree().get_nodes_in_group("player")[0];

func _physics_process(delta):
	velocity = (player_target.position - position).normalized() * speed * delta;
	move_and_slide()
	look_at(player_target.position);
	
func die():
	queue_free()
