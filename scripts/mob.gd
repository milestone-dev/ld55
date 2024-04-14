extends CharacterBody2D
class_name Mob

@export var animation_tree : AnimationTree;

var type: Mobtype

var alive = true
var hp = 0;
var attack_cooldown = 0;

var player_target : Player;
func _ready():
	if not type or not get_tree(): return
	$Sprite2D.texture = type.sprite
	player_target = get_tree().get_nodes_in_group("player")[0];
	hp = type.max_hp
	modulate = type.color
	$AnimationPlayer.speed_scale = type.animation_speed
	scale = Vector2(type.scale,type.scale)

func _physics_process(delta):
	if not get_tree(): return
	if not type: return
	if not player_target:
		player_target = get_tree().get_nodes_in_group("player")[0];
		if not player_target: return

	if !alive: return
	if position.distance_to(player_target.position) < type.attack_range:
		if attack_cooldown <= 0:
			attack_cooldown = type.attack_cooldown_max
			player_target.take_damage(type.attack_damage)
		else:
			attack_cooldown -= delta

	if position.distance_to(player_target.position) > 5:
		velocity = (player_target.position - position).normalized() * type.speed * delta;
	else:
		velocity = Vector2.ZERO
	animation_tree.set("parameters/Walk/blend_position", velocity.x);
	animation_tree.set("parameters/Die/blend_position", velocity.x);
	move_and_slide()
	z_index = position.y

func take_damage(damage : float) -> int:
	hp -= damage;
	if hp <= 0: 
		die();
		return type.experience;
	call_deferred("flash_damage")
	return 0;

func flash_damage():
	modulate = Color.RED
	await get_tree().create_timer(0.15).timeout
	modulate = type.color

func die():
	animation_tree.get("parameters/playback").travel("Die")
	alive = false
	await get_tree().create_timer(1).timeout
	queue_free()
