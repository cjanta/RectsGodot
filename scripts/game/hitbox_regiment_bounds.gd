class_name HitboxRegimentBounds
extends Area2D

signal selection_changed(has_selected_movement :bool)
var has_selected_movement = false:
	set(value):
		has_selected_movement = value
		selection_changed.emit(has_selected_movement)
		
var selected_Mouse_Position

var position_before_drag : Vector2

var regiment : FactionRegiment
@onready var coll_shape : CollisionShape2D = $regiment_bounds
@export var info_label_scene : PackedScene
var info_label_move : InfoLabel
var info_label_charge : InfoLabel

func _ready():
	regiment = get_parent()
	selected_Mouse_Position = get_global_mouse_position()
	coll_shape.shape = coll_shape.shape.duplicate()
	info_label_move = info_label_scene.instantiate()
	add_child(info_label_move)
	info_label_move.visible = false
	info_label_charge = info_label_scene.instantiate()
	info_label_charge.visible = false
	add_child(info_label_charge)

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
	draw_bounds()
	if regiment.is_session_selected_regiment():
		if regiment.type.action_points > 0:
			draw_move_range()
		else:
			info_label_move.visible = false
		if regiment.type.action_points == regiment.type.action_points_max:
			draw_charge_range()
		else:
			info_label_charge.visible = false
	else:
		info_label_move.visible = false
		info_label_charge.visible = false

func draw_bounds():
	var width = 3.0	
	draw_edge_line(Vector2(1,1),Vector2(-1,1), width)
	draw_edge_line(Vector2(-1,1),Vector2(-1,-1), width)
	draw_edge_line(Vector2(-1,-1),Vector2(1,-1), width)
	draw_edge_line(Vector2(1,-1),Vector2(1,1), width)

func draw_move_range():
	var color = regiment.GREY
	var width = 4.0	
	var bounds = regiment.get_current_bounds_extends()
	var move_range = Vector2.UP * regiment.type.action_points
	var from = position + Vector2(-bounds.x,-bounds.y)
	var to = position + Vector2(bounds.x,-bounds.y)
	draw_dashed_line(from + move_range, to + move_range, regiment.GREY, width, 8.0, true)
	var dir = (to + move_range) -  (from + move_range)
	var length_halfed = dir.length() / 2.0
	dir = dir.normalized()
	info_label_move.text = "AP: " + str(snapped(regiment.type.action_points, 0.01))
	info_label_move.visible = true
	info_label_move.position = from + move_range + dir * length_halfed
	info_label_move.position -= info_label_move.get_center()

func draw_charge_range():
	var color = regiment.GREY
	var width = 4.0
	var bounds = regiment.get_current_bounds_extends()
	var from = position + Vector2(-bounds.x,-bounds.y)
	var to = position + Vector2(bounds.x,-bounds.y)
	var charge_range = Vector2.UP * float(regiment.type.charge_range)
	draw_dashed_line(from + charge_range, to + charge_range, regiment.GREY, width, 8.0, true)
	var dir = (to + charge_range) -  (from + charge_range)
	var length_halfed = dir.length() / 2.0
	dir = dir.normalized()
	info_label_charge.text = "Charge: " + str(snapped(regiment.type.charge_range, 0.01))
	info_label_charge.visible = true
	info_label_charge.position = from + charge_range + dir * length_halfed
	info_label_charge.position -= info_label_charge.get_center()
	pass

func draw_edge_line(from_dir : Vector2, to_dir : Vector2, width):
	var color = get_color_by_state()
	var offset = Vector2(width / 2.0, width / 2.0)
	var from = regiment.get_current_bounds_extends()
	from = Vector2(from.x * from_dir.x, from.y * from_dir.y)
	from += Vector2(offset.y * from_dir.x, offset.y * from_dir.y)
	
	var to = regiment.get_current_bounds_extends()
	to = Vector2(to.x * to_dir.x, to.y * to_dir.y)
	to += Vector2(offset.y * to_dir.x, offset.y * to_dir.y)
	draw_line(from, to, color, width, true)

func get_color_by_state():
	if regiment.is_session_selected_regiment():
		return regiment.GREY
	return regiment.faction.faction_type.faction_color









