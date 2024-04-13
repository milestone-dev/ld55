extends CharacterBody2D
class_name Player

@export var max_hp = 100;
@export var max_speed = 30000;
@export var camera : Camera2D;
@export var sprite : Sprite2D;
@export var casting_ui : CastingUI;

var god_mode = false;
var hp = 100;

var mouse_down = false;
var summoning_mode = false;


func _physics_process(delta):
	velocity.x = Input.get_axis("move_left", "move_right")
	velocity.y = Input.get_axis("move_up", "move_down")
	velocity = velocity.normalized() *  max_speed * delta;
	
	sprite.flip_h = velocity.x < 0;
	move_and_slide()
	
func _on_casting_ui_cast_complete(nodes: Array) -> void:
	prints(nodes.map(func(node): return node.name))

func _on_damage_area_body_entered(body):
	if not body is Mob: return;
	var mob = body as Mob;
	take_damage(mob.damage);

func take_damage(damage : float):
	prints("take damage", damage);
	if god_mode: return;
	hp -= damage;
	if hp <= 0:
		die();

func die():
	prints("die");
	get_tree().reload_current_scene()
