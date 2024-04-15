extends AudioStreamPlayer

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("music_toggle"): stream_paused = !stream_paused
	if Input.is_action_just_pressed("sfx_toggle"): Global.sfx_muted = !Global.sfx_muted
