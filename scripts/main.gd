extends Node2D

@export var player : Player
@export var mob_scene : PackedScene
@export var max_mobs : int = 25;
@export var mob_spawn_timer : Timer

var mobtypes: Array[Mobtype]
var levels : Array[Level]
var current_level : Level;

# Called when the node enters the scene tree for the first time.
func _ready():
	levels.assign(Resources.load_resources("res://resources/levels"))
	mobtypes.assign(Resources.load_resources("res://resources/mobtypes"))
	current_level = levels[0]
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("dev_restart"):
		get_tree().reload_current_scene()
	if Input.is_action_just_pressed("dev_godmode"):
		player.god_mode = !player.god_mode;
		player.hud.add_message("GOD MODE " + ("enabled" if player.god_mode else "disabled"));
	if Input.is_action_just_pressed("dev_allspells"):
		player.hud.add_message("Learned all spells (not yet implemented)");

func _on_mob_spawn_timer_timeout():
	if not mob_scene: return
	if get_tree().get_nodes_in_group("mob").size() > current_level.max_concurrent_mobs - 1: return;
	mob_spawn_timer.wait_time = current_level.mob_spawn_cooldown
	var mob = mob_scene.instantiate();
	mob.type = current_level.get_mob_type()
	if not mob.type:
		push_warning("No valid mob")
		return;
	add_child(mob);
	mob.position = _random_new_mob_position()
	
func _screen_to_world(pos: Vector2) -> Vector2:
	return player.camera.get_global_transform_with_canvas().affine_inverse().basis_xform(pos)

func _random_new_mob_position() -> Vector2:
	var margin = Vector2(25, 25)
	#var size = _screen_to_world(get_viewport_rect().size)
	#print("size", size)
	# Use above to find the size to put here, checking veiwport seem to bug on web?
	var size = Vector2(640, 400) / 2 + margin
	var side = randi_range(0, 3)
	var pos = Vector2(randf() * size.x, randf() * size.y)*2 - size
	if side == 0: pos.x = -size.x;
	if side == 1: pos.x = size.x;
	if side == 2: pos.y = -size.y;
	if side == 3: pos.y = size.y;
	pos += player.position
	return pos
	
	
