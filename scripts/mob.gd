extends CharacterBody2D
class_name Mob

@export var max_hp = 100;
@export var speed = 1000;
@export var attack_damage = 5;
@export var attack_cooldown_max = 0.3;
@export var attack_range = 8;
@export var animation_tree : AnimationTree;

var alive = true
var hp = max_hp;
var attack_cooldown = 0;

var player_target : Player;

func _ready():
	player_target = get_tree().get_nodes_in_group("player")[0];

func _physics_process(delta):
	if !alive: return
	if position.distance_to(player_target.position) < attack_range:
		if attack_cooldown <= 0:
			attack_cooldown = attack_cooldown_max
			player_target.take_damage(attack_damage)
		else:
			attack_cooldown -= delta

	if position.distance_to(player_target.position) > 5:
		velocity = (player_target.position - position).normalized() * speed * delta;
	else:
		velocity = Vector2.ZERO
	animation_tree.set("parameters/Walk/blend_position", velocity.x);
	animation_tree.set("parameters/Die/blend_position", velocity.x);
	move_and_slide()

func take_damage(damage : float):
	hp -= damage;
	if hp <= 0: die();

func die():
	animation_tree.get("parameters/playback").travel("Die")
	alive = false
	await get_tree().create_timer(1).timeout
	queue_free()
