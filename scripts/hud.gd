extends Control

class_name HUD

@export var hp_bar : ProgressBar
@export var exp_bar : ProgressBar
@export var label : Label
@export var log_container : VBoxContainer

func add_message(message : String):
	print(message);
	var label = Label.new()
	label.text = message;
	log_container.add_child(label);
	await get_tree().create_timer(3).timeout
	label.queue_free()
