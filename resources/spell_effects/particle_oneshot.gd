extends GPUParticles2D

# sets oneshot, emits, then removes itself.
func _ready():
	one_shot = true;
	emitting = true;
	var time = (lifetime * 2) / speed_scale
	get_tree().create_timer(time).connect("timeout", queue_free)
