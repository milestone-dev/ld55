extends Panel

@export var score_subtitle : Label;

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	$AnimationPlayer.play("blink")
	if score_subtitle != null:
		score_subtitle.text = "You survived for %d seconds and killed %d monsters" % [Global.time_survived, Global.mobs_killed];	
	
func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_win_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_try_again_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")
