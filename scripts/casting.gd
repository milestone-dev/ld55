extends Control

class_name CastingUI

@export var node_container : Control;
@export var line : Line2D;
@export var first_node : Node;
@export var debug_node: Panel;
@export var valid: Array[Panel];

@export_group("Spell drawing")
@export var magnet_enabled = true;
@export var magnet_strength = 16;
@export var magnet_decay = -0.5;
@export var magnet_radius = 24;
@export var snap_distance = 8;


signal cast_complete(nodes);

var conneted_nodes : Array[Control] = [];

var mouse_origin : Vector2
var active = false;

func _ready():
	for panel : Panel in node_container.get_children():
		panel.mouse_entered.connect(_on_node_mouse_entered.bind(panel))

	visible = false;	
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func draw_line_to_node(node:Control):
	line.add_point(node.position + node.pivot_offset - Vector2(line.width/2,line.width/2))
	#line.add_point(node.position + node.pivot_offset - Vector2(line.width/2,line.width/2))

func _on_node_mouse_entered(panel:Panel):
	#if active: draw_line_to_node(panel)
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and active:
		mouse_origin = Vector2.ZERO;
		active = false;
		line.clear_points()
		print("end drag");
		cast_complete.emit(conneted_nodes);
		conneted_nodes.clear()
		visible = false;
		
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and not active:
		visible = true;
		#Input.warp_mouse(panel.position + first_node.position + first_node.pivot_offset)
		mouse_origin = get_viewport().get_mouse_position();
		print("start drag. set mouse origin", mouse_origin);
		line.clear_points()
		draw_line_to_node(first_node)
		conneted_nodes.clear()
		active = true;
	
	if active:
		#move last point to mouse
		var d = get_viewport().get_mouse_position() - mouse_origin;
		
		var pos = line.points[0] + d;
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
				# Move last point to the new node
				line.points[line.points.size() - 1] = node.position + node.pivot_offset - Vector2(line.width/2,line.width/2);
				# Add a new point that will follow the mouse cursor
				line.add_point(line.points[line.points.size() - 1]);
				# Move the mouse origin to the new node
				mouse_origin += pos - (node.position + node.pivot_offset)
		
		#print("mouseleft")
	# Return pos gravitated towards target
func gravitate_towards(pos: Vector2) -> Vector2:
	if not magnet_enabled: return pos;
	var force = Vector2();
	var radius = magnet_radius
	var gravity = magnet_strength
	var alpha = magnet_decay
	for node : Control in node_container.get_children():
		if node in conneted_nodes: continue
		var target = node.position + node.pivot_offset
		var distance = pos.distance_to(target);
		if distance < radius and distance > 0:
			var magnitude = exp(alpha * distance/radius) * (1 - distance / radius)
			force += (target - pos) * magnitude * gravity
	return pos + force
