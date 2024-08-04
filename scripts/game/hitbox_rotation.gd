class_name HitboxRegimentRotation
extends Area2D

signal selection_changed(has_selected_rotation :bool)
var has_selected_rotation = false:
	set(value):
		has_selected_rotation = value
		selection_changed.emit(has_selected_rotation)

var original_drag_vector_up : Vector2
var original_rotation_degrees : float
var regiment : FactionRegiment
@export var icon_sprite : Sprite2D
@export var icon_tex_north : Texture2D
@export var icon_tex_rotate : Texture2D
@export var info_label_scene : PackedScene
var info_label : InfoLabel


func _ready():
	icon_sprite.texture = icon_tex_north
	regiment = get_parent()
	original_drag_vector_up = Vector2.UP.rotated(regiment.global_rotation)
	info_label = info_label_scene.instantiate()
	info_label.visible = false
	add_child(info_label)

func _process(delta):
	queue_redraw()

func _draw():
	if has_selected_rotation and regiment.is_session_selected_regiment():
		var color = regiment.GREY
		var pos = to_local(regiment.global_position)
		var from : Vector2 = pos
		var to : Vector2 = pos + Vector2.UP * 400
		draw_line(from, to, color, 4.0, true)
		
		from = pos
		var target_to = pos + original_drag_vector_up.rotated(-regiment.global_rotation) * 400
		draw_line(from, target_to, color, 4.0, true)
		
		draw_dashed_line(to, target_to,color, 4.0, 8.0, true)
		var dir =  to - target_to
		var l_halfed = dir.length() / 2.0
		dir = dir.normalized()
		info_label.position = target_to + dir * l_halfed
		info_label.position -= info_label.get_center()
		info_label.rotation = Vector2.UP.angle_to(target_to + dir)
		var rotation_delta = get_rotation_delta(original_rotation_degrees,regiment.rotation_degrees )
		rotation_delta = abs(rotation_delta)
		rotation_delta = snapped(rotation_delta, 0.01)
		info_label.text = str(rotation_delta)
		info_label.visible = true
	else:
		info_label.visible = false	

func _input(event):
	if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
				check_endof_drag()

func check_endof_drag():
	if has_selected_rotation:
		has_selected_rotation = false
		icon_sprite.texture = icon_tex_north
		result_actions_points()
		regiment.session_update_selection_display()	

func _physics_process(delta):
	if has_selected_rotation:
		if regiment.type.action_points > 0:
			handleDragnDropRotation(delta)
		else:
			regiment.session_update_selection_display()	

func handleDragnDropRotation(delta):
	rotate_dragged_object(delta)
	regiment.session_update_selection_display()

func rotate_dragged_object(delta):
	var direction = get_global_mouse_position() - regiment.global_position
	var alpha = Vector2.UP.rotated(regiment.global_rotation).angle_to(direction)
	regiment.add_regiment_rotation(alpha)

func result_actions_points():
	var rotation_delta = get_rotation_delta(original_rotation_degrees, regiment.rotation_degrees)
	rotation_delta = abs(rotation_delta)
	rotation_delta = snapped(rotation_delta, 0.01)
	#RULE : TODO: innerhalb des drags noch fehler wenn richtung gewechselt wird -+ +-
	var step_ap = regiment.type.action_points_max / 4.0
	var ap_cost = (rotation_delta / 90.0) * step_ap
	#ap_cost = snapped(ap_cost, 0.01)
	#regiment.type.action_points -= ap_cost
	var prefix = regiment.get_rich_common_prefix()
	var message =  " rotiert " + str(rotation_delta) + "° AP: " + str(ap_cost) 
	regiment.guilog(prefix + message)
	pass

func get_rotation_delta(original_rotation_deg, regiment_rotation_deg):
	return to_360(original_rotation_deg) - to_360(regiment_rotation_deg)

func to_360(rotation_degrees):
	if rotation_degrees < 0:
		return 360 + rotation_degrees 
	return rotation_degrees

func update_position(current_Bounds_extend : Vector2):
	var y_offset = current_Bounds_extend.y + regiment.unit_pixel_size / 2.0
	position += Vector2(0,-y_offset )

func _on_input_event(viewport, event, shape_idx):
	if regiment.is_Selectable && Input.is_action_just_pressed("left_click"):
		if regiment.type.action_points > 0:
			has_selected_rotation = true
			original_drag_vector_up = Vector2.UP.rotated(regiment.global_rotation)
			original_rotation_degrees = regiment.rotation_degrees

func _on_faction_regiment_scene_update_visuals(current_bounds_extends):
	update_position(current_bounds_extends)

func _on_mouse_entered():
	if regiment.is_Selectable:
		icon_sprite.texture = icon_tex_rotate

func _on_mouse_exited():
	if not has_selected_rotation || not regiment.is_Selectable:
		icon_sprite.texture = icon_tex_north
