extends CharacterBody2D
class_name Mob

@export var animation_tree : AnimationTree;

var type: Mobtype

var alive = true
var hp = 0;
var attack_cooldown = 0;

var mob_sfx_cooldown_max = 3;
var mob_sfx_cooldown = 1;

var player_target : Player;
var main : Main;


var dot_damage = 0
var dot_time = 0
var dot_second = 1

func _ready():
	if not type or not get_tree(): return
	$Sprite2D.texture = type.sprite
	player_target = get_tree().get_nodes_in_group("player")[0];
	hp = type.max_hp
	modulate = type.color
	$AnimationPlayer.speed_scale = type.animation_speed
	scale = Vector2(type.scale,type.scale)

func _physics_process(delta):
	if Global.paused: return;
	if not is_inside_tree(): return
	if not type: return
	if not player_target:
		player_target = get_tree().get_nodes_in_group("player")[0];
		if not player_target: return

	if !alive: return
	
	if dot_time > 0:
		dot_second -= delta
		if dot_second <= 0:
			dot_second = 1
			dot_time -= 1
			player_target.add_experience(take_damage(dot_damage))

	if position.distance_to(player_target.position) < 96:
		if mob_sfx_cooldown <= 0:
			$MobSfx.stream = type.mob_sfx.pick_random()
			$MobSfx.pitch_scale = randf_range(0.9, 1.1);
			if !Global.sfx_muted: $MobSfx.play()
			mob_sfx_cooldown = randf_range(mob_sfx_cooldown_max, mob_sfx_cooldown_max * 3);
		else: mob_sfx_cooldown -= delta;

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
	
	velocity *= Global.speed_factor
	
	animation_tree.set("parameters/Walk/blend_position", velocity.x);
	animation_tree.set("parameters/Die/blend_position", velocity.x);
	move_and_slide()

func take_damage(damage : float) -> int:
	hp -= damage;
	$MobImpactSfx.pitch_scale = randf_range(0.9, 1.1);
	if !Global.sfx_muted: $MobImpactSfx.play();
	if hp <= 0: 
		die();
		return type.experience;
	call_deferred("flash_damage")
	return 0;

func flash_damage():
	if dot_time > 0:
		modulate = Color.LAWN_GREEN
	else:
		modulate = Color.RED
	await get_tree().create_timer(0.15).timeout
	modulate = type.color

func die():
	Global.mobs_killed += 1
	if not is_inside_tree(): return;
	animation_tree.get("parameters/playback").travel("Die")
	alive = false
	await get_tree().create_timer(1).timeout
	queue_free()
