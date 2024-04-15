extends Sprite2D
class_name Projectile

@export var area : Area2D
@export var align_rotation = true
@export_category("Particle Effect")
@export var particle_effect : GPUParticles2D
@export var align_particles_rotation: bool = false

var spell: Spell
var player : Player
var velocity : Vector2
var speed : float = 400;
var hits : int = 1;
var age: float;
var alive = true

func _ready() -> void:
	if not spell: return
	hits = spell.projectile_max_hits;
	if align_rotation:
		look_at(position + velocity)
	if particle_effect:
		particle_effect.emitting = true
		if align_particles_rotation:
			var mat = particle_effect.process_material as ParticleProcessMaterial
			mat.angle_max = 360 - rotation_degrees
			mat.angle_min = 360 - rotation_degrees

func _process(delta: float) -> void:
	if not spell: return
	if alive:
		position += velocity * (speed * Global.speed_factor) * delta
		
	age += delta;
	if age > 10:
		queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if not alive: return
	if not body is Mob or not player: return
	var mob : Mob = body as Mob
	if not mob.alive: return
	player.add_experience(mob.take_damage(spell.attack_damage));
	hits-=1
	if hits <= 0: stop()
	
func stop():
	alive = false
	if particle_effect:
		particle_effect.emitting = false
	texture = null
	
