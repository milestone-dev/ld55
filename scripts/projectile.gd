extends Sprite2D
class_name Projectile

@export var area : Area2D
var damage : float
var player : Player
var velocity : Vector2
var speed : float = 40;

func _process(delta: float) -> void:
	position += velocity * speed * delta

func _on_area_2d_body_entered(body: Node2D) -> void:
	if not body is Mob or not player: return
	var mob : Mob = body as Mob
	player.add_experience(mob.take_damage(damage));
