extends Control

class_name HUD

@export var hp_bar : ProgressBar
@export var exp_bar : ProgressBar
@export var label : Label
@export var log_container : VBoxContainer
@export var click_to_cast_label : Label;

func add_message(message : String):
	#print(message);
	var label = Label.new()
	label.text = message;
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER;
	label.add_theme_font_override("font", load("res://assets/fonts/IMFellDWPica-Regular.ttf"));
	label.add_theme_font_size_override("font", 18);
	log_container.add_child(label);
	await get_tree().create_timer(3).timeout
	label.queue_free()
