class_name Regiment_Bounds
extends Area2D

var has_selected_movement = false
var selected_Mouse_Position
var regiment : Faction_Regiment
@onready var coll_shape : CollisionShape2D = $regiment_bounds

func _ready():
	regiment = get_parent()
	selected_Mouse_Position = get_global_mouse_position()
	coll_shape = coll_shape.duplicate()

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
			check_endof_drag()

func check_endof_drag():
	if has_selected_movement:
		has_selected_movement = false

func _physics_process(delta):
	if has_selected_movement:
		handleDragnDropMovement(delta)

func handleDragnDropMovement(delta):
	var action_points = move()

func update_extends(current_bounds_extends :Vector2):
	coll_shape.shape.extents = current_bounds_extends

func move():
		var dragVector = get_global_mouse_position() - selected_Mouse_Position
		var rotadetForward = Vector2.UP.rotated(regiment.rotation)		
		var dot = rotadetForward.dot(dragVector)
			
		if has_selected_movement and dot > 0:
			regiment.global_position += rotadetForward * dot
			selected_Mouse_Position = get_global_mouse_position()
			return abs(dot)
		elif has_selected_movement and dot < 0:
			var rotatedBack = Vector2.DOWN.rotated(regiment.rotation)
			regiment.global_position -= rotatedBack * dot
			selected_Mouse_Position = get_global_mouse_position()
			return abs(dot)
		return 0
	
func _on_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("left_click"):
		has_selected_movement = true
		selected_Mouse_Position = get_global_mouse_position()
