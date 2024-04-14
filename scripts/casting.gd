extends Control

class_name CastingUI

@export var node_container : Control;
@export var line : Line2D;
@export var first_node : Node;
@export var debug_node: Panel;
@export var valid: Array[Panel];
@export var player: Player;
@export var hint_runes : Array[TextureRect];

@export_group("Spell drawing")
@export var magnet_enabled = true;
@export var magnet_strength = 1;
@export var magnet_decay = -0.1;
@export var magnet_radius = 64;
@export var snap_distance = 4;


signal cast_complete(nodes);

var conneted_nodes : Array[Control] = [];

var mouse_origin : Vector2
var active = false;

func _ready():
	visible = false;
	reset_nodes();
	#Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN);

func reset_nodes():
	for node : Control in $NodeContainers.get_children():
		node.scale = Vector2.ONE;
		node.modulate = Color.DIM_GRAY;
	conneted_nodes.clear();

func draw_line_to_node(node:Control, add_node : bool):
	if add_node: conneted_nodes.push_back(node)
	line.add_point(node.position + node.pivot_offset - Vector2(line.width/2,line.width/2))
	#line.add_point(node.position + node.pivot_offset - Vector2(line.width/2,line.width/2))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Global.paused: return;
	var is_holding_activation_key = Input.is_key_pressed(KEY_SPACE)
	if not is_holding_activation_key and active:
		mouse_origin = Vector2.ZERO;
		active = false;
		line.clear_points()
		#print("end drag");
		cast_complete.emit(conneted_nodes);
		reset_nodes();
		visible = false;
		Global.speed_factor = 1
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		
	if is_holding_activation_key and not active:
		for tr : TextureRect in hint_runes:
			tr.hide()
			var index = hint_runes.find(tr)
			if player.learned_spells.size() >= index+1 and player.learned_spells[index] != null:
				tr.texture = player.learned_spells[index].spell_guide
				tr.show()
		visible = true;
		#Input.warp_mouse(panel.position + first_node.position + first_node.pivot_offset)
		mouse_origin = get_viewport().get_mouse_position();
		#print("start drag. set mouse origin", mouse_origin);
		line.clear_points()
		reset_nodes()
		draw_line_to_node(first_node, true)
		draw_line_to_node(first_node, false) #and one for the mouse pointer		
		active = true;
		Global.speed_factor = 0.2
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	
	if active:
		Global.speed_factor = 0.2
		#move last point to mouse
		var d = get_viewport().get_mouse_position() - mouse_origin;
		var pos = line.points[0] + d;
		if debug_node:
			debug_node.position = pos - debug_node.pivot_offset;
		var spell_pos = gravitate_towards(pos);
		
		#print(get_viewport().get_mouse_position() - mouse_origin);
		line.points[line.points.size() - 1] = spell_pos;
		
		for node : Control in node_container.get_children():
			if (node in conneted_nodes): continue;
			
			# Found node within snapping distance, create a new point
			if (node.position + node.pivot_offset).distance_to(spell_pos) < snap_distance:
				# Add node to connected nodes list
				conneted_nodes.push_back(node)
				node.modulate = Color.WHITE;
				node.scale = Vector2.ONE * 1.5;
				(node.get_node("AudioStreamPlayer") as AudioStreamPlayer).play()
				# Move last point to the new node
				line.points[line.points.size() - 1] = node.position + node.pivot_offset - Vector2(line.width/2,line.width/2);
				# Add a new point that will follow the mouse cursor
				line.add_point(line.points[line.points.size() - 1]);
				# Move the mouse origin to the new node
				mouse_origin += pos - (node.position + node.pivot_offset)

func gravitate_towards(pos: Vector2) -> Vector2:
	if not magnet_enabled: return pos;
	var force = Vector2();
	var radius = magnet_radius
	var gravity = magnet_strength
	var alpha = magnet_decay
	var closest: Control
	var distance = 999999
	for node : Control in node_container.get_children():
		if node in conneted_nodes: continue
		var target = node.position + node.pivot_offset
		if pos.distance_to(target) < distance: 
			distance = pos.distance_to(target)
			closest = node
	if closest:
		var target = closest.position + closest.pivot_offset
		if distance < radius and distance > 0:
			var magnitude = exp(alpha * distance/radius) * (1 - distance / radius)
			force += (target - pos) * magnitude * 1/gravity
	
	return pos + force
