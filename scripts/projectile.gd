extends Sprite2D
class_name Projectile

@export var area : Area2D
@export var wave_effect : GPUParticles2D

var damage : float
var player : Player
var velocity : Vector2
var speed : float = 400;
var hits : int = 1;
var age: float;
var alive = true

func _ready() -> void:
	look_at(position + velocity)
	var mat = wave_effect.process_material as ParticleProcessMaterial
	mat.angle_max = 360 - rotation_degrees
	mat.angle_min = 360 - rotation_degrees
	print(rotation_degrees)

func _process(delta: float) -> void:
	if alive:
	position += velocity * (speed * Global.speed_factor) * delta
		position += velocity * speed * delta
	
	age += delta;
	if age > 10:
		queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if not body is Mob or not player: return
	var mob : Mob = body as Mob
	player.add_experience(mob.take_damage(damage));
	hits-=1
	if hits <= 0: stop()
	
func stop():
	alive = false
	wave_effect.emitting = false
	texture = null
	
