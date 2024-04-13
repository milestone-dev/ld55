extends Node2D

@export var player : Player
@export var mob_scene : PackedScene
@export var max_mobs : int = 25;

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Hello TrollDoom!")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("dev_restart"):
		print ("RESTARTING SCENE")
		get_tree().reload_current_scene()
	if Input.is_action_just_pressed("dev_godmode"):
		print ("TOGGLING GOD MODE")
		player.god_mode = !player.god_mode;
	

func _on_mob_spawn_timer_timeout():
	#print("spawn mob");	
	if get_tree().get_nodes_in_group("mob").size() > max_mobs - 1: return;
	if not mob_scene: return
	var mob = mob_scene.instantiate();
	mob.position = Vector2(randf_range(-300, 300),randf_range(-300, 300));	
	add_child(mob);
