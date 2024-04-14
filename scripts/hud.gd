extends Control

class_name HUD

@export var hp_bar : ProgressBar
@export var exp_bar : ProgressBar
@export var label : Label

func add_message(message : String):
	print(message);
	var label = Label.new()
	label.text = message;
	$VBoxContainer.add_child(label);
	await get_tree().create_timer(3).timeout
	label.queue_free()
