extends Node2D

@export var player : Player
@export var mob_scene : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Hello world")
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_mob_spawn_timer_timeout():
	print("spawn");	
	if not mob_scene: return
	var mob = mob_scene.instantiate();
	add_child(mob);
