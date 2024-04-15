extends Panel

@export var score_subtitle : Label;

@export var preload_scenes : Array[PackedScene]

func _ready() -> void:
	for scene : PackedScene in preload_scenes:
		scene.instantiate();
	
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if has_node("AnimationPlayer"):
		get_node("AnimationPlayer").play("blink")
	if score_subtitle != null:
		score_subtitle.text = "You survived for %d seconds and killed %d monsters" % [Global.time_survived, Global.mobs_killed];

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().change_scene_to_file("res://scenes/main.tscn")
	
func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_win_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_try_again_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")
