class_name Regiment_rotation
extends Area2D

signal selection_changed(has_selected_rotation :bool)
var has_selected_rotation = false:
	set(value):
		has_selected_rotation = value
		selection_changed.emit(has_selected_rotation)

var original_drag_vector_up
var regiment : Faction_Regiment
var icon_sprite : Sprite2D
var icon_tex_north
var icon_tex_rotate

func _ready():
	icon_sprite = $rotation_circle/icon
	icon_tex_north = load("res://grfx/icon_PointNorth32.png")
	icon_tex_rotate = load("res://grfx/icon_Rotate32.png")
	icon_sprite.texture = icon_tex_north
	regiment = get_parent()
	original_drag_vector_up = Vector2.UP.rotated(regiment.global_rotation)

func _input(event):
	if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
				check_endof_drag()

func check_endof_drag():
	if has_selected_rotation:
		has_selected_rotation = false
		icon_sprite.texture = icon_tex_north
		var result = Vector2.UP.rotated(regiment.global_rotation).angle_to(original_drag_vector_up)
		regiment.type.action_points -= abs(rad_to_deg(result))
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
	regiment.global_rotation += alpha

func _process(delta):
	pass

func update_position(current_Bounds_extend : Vector2):
	var y_offset = current_Bounds_extend.y + regiment.unit_pixel_size / 2.0
	position += Vector2(0,-y_offset )

func _on_input_event(viewport, event, shape_idx):
	if regiment.is_Selectable && Input.is_action_just_pressed("left_click"):
		if regiment.type.action_points > -1:
			has_selected_rotation = true
			original_drag_vector_up = Vector2.UP.rotated(regiment.global_rotation)

func _on_faction_regiment_scene_update_visuals(current_bounds_extends):
	update_position(current_bounds_extends)

func _on_mouse_entered():
	if regiment.is_Selectable:
		icon_sprite.texture = icon_tex_rotate

func _on_mouse_exited():
	if not has_selected_rotation || not regiment.is_Selectable:
		icon_sprite.texture = icon_tex_north
