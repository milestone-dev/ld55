extends CharacterBody2D
class_name Player

@export var max_hp : float = 100;
@export var max_speed : float = 8000;
@export var attack_cooldown_max : float= 0.85;

@export var camera : Camera2D;
@export var sprite : Sprite2D;
@export var casting_ui : CastingUI;
@export var hud : HUD;

@export var projectile_scene : PackedScene;

@export var animation_tree : AnimationTree;

var available_spells: Array[Spell];

var god_mode = false;
var hp : float = 100;
var exp : int = 0;
var max_exp : int = 100;
var level : int = 1;
var attack_cooldown : float = 0;

var mouse_down = false;
var summoning_mode = false;

#spell effects
var current_single_fire_projectile_spell : Spell
var current_replace_projectile_spell : Spell
var current_timed_projectile_spells : Array[Spell]
var current_aoe_effect_spells : Array[Spell]
# single-fire AOE happens immediately and don't need tracking

func _ready() -> void:
	for file_name : String in DirAccess.open("res://resources/spells").get_files():
		print (file_name)
		available_spells.push_back(ResourceLoader.load("res://resources/spells/" + file_name));
	
func _physics_process(delta):
	
	if attack_cooldown > 0: attack_cooldown -= delta
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):	
		if current_single_fire_projectile_spell != null:
			shoot_projectile(current_single_fire_projectile_spell);
			current_single_fire_projectile_spell = null
		elif attack_cooldown <= 0:
			attack_cooldown = attack_cooldown_max
			shoot_projectile();
	
	hud.hp_bar.value = hp;
	hud.hp_bar.max_value = max_hp;
	
	hud.exp_bar.value = exp;
	hud.exp_bar.max_value = max_exp;
	
	hud.label.text = "TrollDoom 0.1"
	hud.label.text += "\nLevel %s" % level;
	hud.label.text += "\n\n"
	hud.label.text += "\nHP %s/%s" % [hp, max_hp]
	hud.label.text += "\nEXP %s/%s" % [exp, max_exp]
	if god_mode: hud.label.text += "\nGOD MODE"
	
	velocity.x = Input.get_axis("move_left", "move_right")
	velocity.y = Input.get_axis("move_up", "move_down")
	velocity = velocity.normalized() *  max_speed * delta;
	
	if velocity == Vector2.ZERO:
		animation_tree.get("parameters/playback").travel("Idle")
	else:
		animation_tree.get("parameters/playback").travel("Walk")
		animation_tree.set("parameters/Idle/blend_position", velocity.x);
		animation_tree.set("parameters/Walk/blend_position", velocity.x);
		move_and_slide()

func shoot_projectile(projectile_spell : Spell = null):
	var proj = projectile_scene.instantiate() as Projectile
	proj.player = self;
	proj.position = position
	proj.look_at(velocity)
	proj.velocity = (get_global_mouse_position() - global_position).normalized()
	if projectile_spell:
		proj.damage = projectile_spell.damage
		proj.texture = projectile_spell.projectile_texture
	else:
		proj.damage = 50
		
	get_parent().add_child(proj)
	
func _on_casting_ui_cast_complete(nodes: Array[Control]) -> void:
	print(available_spells)
	var code : String;
	for node : Control in nodes:
		code += node.name
	
	var spell : Spell = null
	for potential_spell : Spell in available_spells:
		if potential_spell.validate_code(code):
			spell = potential_spell
			break
			
	if not spell: return	
	
	if spell.effect_area_behavior == Spell.SpellEffectAreaBehavior.SINGLE_FIRE:
		for mob : Mob in get_tree().get_nodes_in_group("mob"):
			if position.distance_to(mob.position) < spell.range:
				add_experience(mob.take_damage(spell.damage))
	elif spell.projectile_behavior == Spell.SpellProjectileBehavior.SINGLE_FIRE:
		current_single_fire_projectile_spell = spell
	
	prints("Casting spell", spell.name)

func add_experience(experience : int):
	exp += experience
	if exp >= max_exp:
		level += 1
		exp -= max_exp
		max_exp *= 1.5

func take_damage(damage : float):
	prints("take damage", damage);
	if god_mode: return;
	hp -= damage;
	if hp <= 0: die();

func die():
	prints("die");
	get_tree().reload_current_scene()
