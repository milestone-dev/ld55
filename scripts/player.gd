extends CharacterBody2D
class_name Player

signal level_change

@export var max_hp : float = 100;
@export var max_speed : float = 8000;
@export var attack_cooldown_max : float = 0.85;
@export var default_attack_damage : float = 50;

@export var camera : Camera2D;
@export var sprite : Sprite2D;
@export var casting_ui : CastingUI;
@export var hud : HUD;
@export var shop : Shop

@export var level_experience_requirements = [
	0,
	300,
	800,
	1800,
	3000,
	7500,
	17000,
	40000,
	100000,
	500000
];

@export_category("TrollDOOM")
@export var projectile_scene : PackedScene;
@export var lose_scene : PackedScene;
# Fallback if a spell does not define one.
@export var default_projectile_scene : PackedScene;
@export var animation_tree : AnimationTree;
@export var base_attack_spell: Spell;

var available_spells: Array[Spell];
var learned_spells: Array[Spell];

var level : int = 0; # 0 = Level 1
var god_mode = false;
var hp : float = 100;
var experience : int = 0;
var max_experience : int = 100;
var attack_cooldown : float = 0;

var mouse_down = false;
var summoning_mode = false;

#spell effects
var current_single_fire_projectile_spell : Spell
var current_replace_projectile_spell : Spell
var current_timed_projectile_spells : Array[SpellTimer]
var current_aoe_effect_spells : Array[SpellTimer]
# single-fire AOE happens immediately and don't need tracking

func _ready() -> void:
	available_spells.assign(Resources.load_resources("res://resources/spells/"))
	shop.learn_spell.connect(learn_spell)
	casting_ui.player = self
	
func learn_spell(spell: Spell):
	learned_spells.push_back(spell)
	hud.add_message("You learned " + spell.name + "!");
	Global.paused = false
	
func _physics_process(delta):
	if Global.paused: return;
	if attack_cooldown > 0: attack_cooldown -= delta
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and Global.speed_factor == 1:
		if current_single_fire_projectile_spell != null:
			shoot_projectile(current_single_fire_projectile_spell);
			current_single_fire_projectile_spell = null
			attack_cooldown = attack_cooldown_max
		elif base_attack_spell and attack_cooldown <= 0:
			shoot_projectile(base_attack_spell);
			attack_cooldown = attack_cooldown_max
			
	# process timers
	for projectile_spell_timer : SpellTimer in current_timed_projectile_spells:
		if projectile_spell_timer.update(delta): current_timed_projectile_spells.erase(projectile_spell_timer)
	
	for area_spell_timer : SpellTimer in current_aoe_effect_spells:
		if area_spell_timer.update(delta): current_aoe_effect_spells.erase(area_spell_timer)
	
	hud.hp_bar.value = hp;
	hud.hp_bar.max_value = max_hp;
	
	hud.exp_bar.value = experience;
	hud.exp_bar.max_value = max_experience;
	
	hud.label.text = "\nLevel %d" % (level + 1);
	hud.label.text += "\nMobs: %d" % (get_tree().get_nodes_in_group("mob").size());
	
	if false:
		hud.label.text += "\n\n"
		hud.label.text += "\nHP %s/%s" % [hp, max_hp]
		hud.label.text += "\nEXP %s/%s" % [experience, max_experience]
		hud.label.text += "\nP: Test Shop"
		hud.label.text += "\nM: God Mode"
		hud.label.text += "\nL: All Spells"
		hud.label.text += "\nK: Restart Run"
		hud.label.text += "\nO: Kill all enemies"
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
		$DrumSprite.flip_h = velocity.x < 0
		velocity *= Global.speed_factor
		move_and_slide()

func shoot_projectile(projectile_spell : Spell, random_direction = false):
	assert(projectile_spell, "You forgot to supply the spell")
	$DrumSprite/AnimationPlayer.play("attack")
	
	var proj_prefab = default_projectile_scene
	if projectile_spell.projectile_scene:
		proj_prefab = projectile_spell.projectile_scene
	var proj = proj_prefab.instantiate() as Projectile
	proj.player = self;
	proj.spell = projectile_spell
	proj.position = position
	if random_direction: proj.velocity = Vector2(randf_range(-1,1),randf_range(-1,1));
	else: proj.velocity = (get_global_mouse_position() - global_position).normalized()
		
	get_parent().add_child(proj)
	
func _on_casting_ui_cast_complete(nodes: Array[Control]) -> void:
	var code : String = "";
	for node : Control in nodes:
		code += node.name
	
	var spell : Spell = null
	for potential_spell : Spell in learned_spells:
		if potential_spell.validate_code(code):
			spell = potential_spell
			break
			
	if not spell:
		hud.add_message("No spell or spell not known");
		return
	
	match spell.effect_area_behavior:
		Spell.SpellEffectAreaBehavior.SINGLE_FIRE:
			if spell.effect:
				var effect = spell.effect.instantiate()
				add_child(effect)
			for mob : Mob in get_tree().get_nodes_in_group("mob"):
				if position.distance_to(mob.position) < spell.attack_range:
					add_experience(mob.take_damage(spell.attack_damage))
		Spell.SpellEffectAreaBehavior.TIMED:
			current_aoe_effect_spells.push_back(SpellTimer.new(self, spell))
	
	match spell.projectile_behavior:
		Spell.SpellProjectileBehavior.ADD_TIMED:
			current_timed_projectile_spells.push_back(SpellTimer.new(self, spell))
		Spell.SpellProjectileBehavior.REPLACE_TIMED:
			pass
		Spell.SpellProjectileBehavior.SINGLE_FIRE:
			current_single_fire_projectile_spell = spell
		
	hud.add_message("Casting spell " + spell.name);

func add_experience(input_experience : int):
	experience += input_experience
	if experience >= max_experience:
		experience -= max_experience
		level_up()

func level_up():
	level += 1
	max_experience = level_experience_requirements[level]
	level_change.emit()
	shop.present_spell_choice(available_spells, learned_spells)
	Global.paused = true

func take_damage(damage : float):
	# prints("take damage", damage);
	if god_mode: return;
	hp -= damage;
	call_deferred("flash_damage")
	if hp <= 0: die();
	
func flash_damage():
	if not is_inside_tree(): return
	modulate = Color.RED
	await get_tree().create_timer(0.15).timeout
	modulate = Color.WHITE

func die():
	get_tree().change_scene_to_packed(lose_scene)
