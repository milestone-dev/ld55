extends Node2D

class_name Main

@export var player : Player
@export var mob_scene : PackedScene
@export var max_mobs : int = 25;
@export var mob_spawn_timer : Timer
@export var world_entities : Node2D

@export var win_scene : PackedScene
@export var lose_scene : PackedScene

var mobtypes: Array[Mobtype]
var levels : Array[Level]
var current_level : Level;

const DEFAULT_SPAWN_COOLDOWN = 0.5
var current_spawn_cooldown : float = DEFAULT_SPAWN_COOLDOWN;
var current_spawn_cooldown_target : float = 0;

var has_spawned_bergatroll = false

var paused = false

# Called when the node enters the scene tree for the first time.
func _ready():
	levels.assign(Resources.load_resources("res://resources/levels"))
	mobtypes.assign(Resources.load_resources("res://resources/mobtypes"))
	current_level = levels[player.level]
	start_level()

func start_level():
	player.shop.present_spell_choice(player.available_spells, player.learned_spells)
	Global.paused = true
	
func _process(_delta):
	if paused or not is_inside_tree(): return;
	if Input.is_action_just_pressed("decrease_spell_mouse_sensitivity"):
		Global.spell_mouse_sensitivity = max(0.1, Global.spell_mouse_sensitivity - 0.1);
	if Input.is_action_just_pressed("increase_spell_mouse_sensitivity"):
		Global.spell_mouse_sensitivity = min(1, Global.spell_mouse_sensitivity + 0.1);
	if Input.is_action_just_pressed("dev_restart"):
		player.die()
		return
	if Input.is_action_just_pressed("dev_godmode"):
		player.god_mode = !player.god_mode;
		#player.hud.add_message("GOD MODE " + ("enabled" if player.god_mode else "disabled"));
	if Input.is_action_just_pressed("dev_allspells"):
		player.learned_spells = player.available_spells
		#player.hud.add_message("Learned all spells");
	if Input.is_action_just_pressed("dev_clearscreen"):
		for mob :Mob in get_tree().get_nodes_in_group("mob"):
			player.add_experience(mob.take_damage(100000))
		#player.hud.add_message("Killing all enemies");
		
	for mob : Mob in get_tree().get_nodes_in_group("mob"):
		if mob.global_position.distance_to(player.global_position) > 640:
			var pos = mob.position
			mob.position = _random_new_mob_position()

func _on_mob_spawn_timer_timeout():
	if paused: return;
	if not mob_scene or not current_level: return
	if get_tree().get_nodes_in_group("mob").size() > current_level.max_concurrent_mobs - 1: return;
	
	# Reset spawn cooldown	
	current_spawn_cooldown = lerp(current_spawn_cooldown, current_spawn_cooldown_target, 0.01);
	mob_spawn_timer.wait_time = current_spawn_cooldown
	
	var mob = mob_scene.instantiate();
	mob.main = self;
	mob.type = current_level.get_mob_type()
	if not mob.type:
		push_warning("No valid mob")
		return;
		
	if mob.type.experience > 100000:
		if has_spawned_bergatroll: return
		has_spawned_bergatroll = true
	world_entities.add_child(mob);
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

func _on_player_level_change() -> void:
	if player.level > levels.size() - 1:
		current_level = null
		win()
		return
	else: current_level = levels[player.level]
	current_spawn_cooldown = DEFAULT_SPAWN_COOLDOWN
	current_spawn_cooldown_target = current_level.mob_spawn_cooldown

func win():
	get_tree().change_scene_to_packed(win_scene)
	
func lose():
	get_tree().change_scene_to_packed(lose_scene)
