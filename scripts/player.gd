extends CharacterBody2D
class_name Player

@export var max_hp = 100;
@export var max_speed = 30000;
@export var camera : Camera2D;
@export var sprite : Sprite2D;
@export var casting_ui : CastingUI;

@export var animation_tree : AnimationTree;

var available_spells: Array[Spell];

var god_mode = false;
var hp = 100;

var mouse_down = false;
var summoning_mode = false;

func _ready() -> void:
	for file_name : String in DirAccess.open("res://resources/spells").get_files():
		print (file_name)
		available_spells.push_back(ResourceLoader.load("res://resources/spells/" + file_name));
	
func _physics_process(delta):
	velocity.x = Input.get_axis("move_left", "move_right")
	velocity.y = Input.get_axis("move_up", "move_down")
	velocity = velocity.normalized() *  max_speed * delta;
	
	if velocity == Vector2.ZERO:
		animation_tree.get("parameters/playback").travel("Idle")
	else:
		animation_tree.get("parameters/playback").travel("Walk")
		animation_tree.set("parameters/Idle/blend_position", velocity);
		animation_tree.set("parameters/Walk/blend_position", velocity);
		move_and_slide()
	
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
	
	for mob : Mob in get_tree().get_nodes_in_group("mob"):
		if position.distance_to(mob.position) < spell.range:
			mob.take_damage(spell.damage)
	
	print("Casting spell", spell.name)

func _on_damage_area_body_entered(body):
	if not body is Mob: return;
	var mob = body as Mob;
	take_damage(mob.damage);

func take_damage(damage : float):
	prints("take damage", damage);
	if god_mode: return;
	hp -= damage;
	if hp <= 0: die();

func die():
	prints("die");
	get_tree().reload_current_scene()
