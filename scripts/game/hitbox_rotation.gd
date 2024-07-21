class_name Regiment_rotation
extends Area2D

var has_selected_rotation = false
var selected_Mouse_Position
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
	selected_Mouse_Position = get_global_mouse_position()

func _input(event):
	if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
				check_endof_drag()

func check_endof_drag():
	if has_selected_rotation:
		has_selected_rotation = false
		icon_sprite.texture = icon_tex_north

func _physics_process(delta):
	if has_selected_rotation:
		handleDragnDropRotation(delta)

func handleDragnDropRotation(delta):
	var action_points =	rotate_dragged_object(delta)

func rotate_dragged_object(delta):
	var direction = get_global_mouse_position() - regiment.global_position
	var alpha = Vector2.UP.rotated(regiment.rotation).angle_to(direction)
	regiment.global_rotation += alpha
	return alpha

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update_position(current_Bounds_extend : Vector2):
	var y_offset = current_Bounds_extend.y + regiment.unit_pixel_size / 2.0
	position += Vector2(0,-y_offset )

func _on_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("left_click"):
		has_selected_rotation = true
		selected_Mouse_Position = get_global_mouse_position()

func _on_faction_regiment_scene_update_visuals(current_bounds_extends):
	update_position(current_bounds_extends)

func _on_mouse_entered():
	icon_sprite.texture = icon_tex_rotate

func _on_mouse_exited():
	if not has_selected_rotation:
		icon_sprite.texture = icon_tex_north
