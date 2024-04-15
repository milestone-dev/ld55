#@tool
extends AreaOfEffect

@export_range(0, 180) var angle: float = 45
@export_range(10, 200) var range: float = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	if not spell: return
	if not collider:
		collider = $Area2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not spell: return
	if Engine.is_editor_hint():
		var rad = deg_to_rad(angle)/2
		$Area2D/CollisionPolygon2D.polygon[1].x = cos(rad)*range
		$Area2D/CollisionPolygon2D.polygon[1].y = sin(rad)*range
		$Area2D/CollisionPolygon2D.polygon[2].x = cos(TAU-rad)*range
		$Area2D/CollisionPolygon2D.polygon[2].y = sin(TAU-rad)*range
		var mat = $GPUParticles2D.process_material as ParticleProcessMaterial
		mat.spread = angle / 2
		$GPUParticles2D.lifetime = range/100;
		return
		
	if look_at_pointer:
		var pos = get_global_mouse_position()
		look_at(pos)
		
