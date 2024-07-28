class_name Regiment_Bounds
extends Area2D

signal selection_changed(has_selected_movement :bool)
var has_selected_movement = false:
	set(value):
		has_selected_movement = value
		selection_changed.emit(has_selected_movement)
		
var selected_Mouse_Position

var position_before_drag : Vector2

var regiment : Faction_Regiment
@onready var coll_shape : CollisionShape2D = $regiment_bounds

func _ready():
	regiment = get_parent()
	selected_Mouse_Position = get_global_mouse_position()
	coll_shape.shape = coll_shape.shape.duplicate()
func _process(delta):
	queue_redraw()

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
			check_endof_drag()

func check_endof_drag():
	if has_selected_movement:
		has_selected_movement = false
		regiment.session_update_selection_display()

func _physics_process(delta):
	if has_selected_movement:
		if regiment.type.action_points > 0:
			handleDragnDropMovement(delta)
		else:
			regiment.session_update_selection_display()	

func handleDragnDropMovement(delta):
	regiment.type.action_points -= move(delta)
	regiment.session_update_selection_display()

func update_extends(current_bounds_extends :Vector2):
	coll_shape.shape.extents = current_bounds_extends

func move(delta):
		var dragVector = get_global_mouse_position() - selected_Mouse_Position
		var rotadetForward = Vector2.UP.rotated(regiment.rotation).normalized()	
		var dot = rotadetForward.dot(dragVector)
		if has_selected_movement and dot >= 0:
			regiment.global_position += rotadetForward * dot
			selected_Mouse_Position = get_global_mouse_position()
			return dot
		return 0
	
func _on_input_event(viewport, event, shape_idx):
	if regiment.is_Selectable && Input.is_action_just_pressed("left_click"):
		if regiment.type.action_points > -1:
			has_selected_movement = true
			position_before_drag = regiment.global_position
			selected_Mouse_Position = get_global_mouse_position()

func _on_faction_regiment_scene_update_visuals(current_bounds_extends):
	update_extends(current_bounds_extends)

func _draw():
	if regiment.is_session_selected_regiment():
		draw_bounds()

func draw_bounds():
	var width = 3.0	
	draw_edge_line(Vector2(1,1),Vector2(-1,1), width)
	draw_edge_line(Vector2(-1,1),Vector2(-1,-1), width)
	draw_edge_line(Vector2(-1,-1),Vector2(1,-1), width)
	draw_edge_line(Vector2(1,-1),Vector2(1,1), width)

func draw_edge_line(from_dir : Vector2, to_dir : Vector2, width):
	var color = Color.WHITE
	var offset = Vector2(width / 2.0, width / 2.0)
	var from = regiment.get_current_bounds_extends()
	from = Vector2(from.x * from_dir.x, from.y * from_dir.y)
	from += Vector2(offset.y * from_dir.x, offset.y * from_dir.y)
	
	var to = regiment.get_current_bounds_extends()
	to = Vector2(to.x * to_dir.x, to.y * to_dir.y)
	to += Vector2(offset.y * to_dir.x, offset.y * to_dir.y)
	draw_line(from, to, color, width, true)











