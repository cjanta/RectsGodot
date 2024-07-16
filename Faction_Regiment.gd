class_name Faction_Regiment
extends Node2D

var has_selected_rotation = false
var selected = false
var selected_Mouse_Position

@export var faction_units : Array[Faction_Unit] = []
@export var setup_facing_dir : Vector2 = Vector2.ZERO
@export var setup_pos : Vector2 = Vector2.ZERO

@onready var hitbox_polygone = $Area2D/CollisionPolygon2D
@onready var hitbox_regiment_bounds = $hitbox_regiment_bounds/regiment_bounds
@onready var hitbox_rotation = $hitbox_rotation/rotation_hitbox
@onready var node_to_update = [$hitbox_rotation/rotation_hitbox]
var shape_extends_total = Vector2.ZERO
var	relative_position = Vector2.ZERO
var	regiment_bounds =  null
var regiment_unit_size = Vector3(25,10,2)
var unit_pixel_size = 32.0

var isIni = true

var faction_unit_preload = preload("res://faction_unit.tscn")

func _ready():
	selected_Mouse_Position = get_global_mouse_position()
	regiment_unit_size.z = ceil(regiment_unit_size.x / regiment_unit_size.y)
	hitbox_regiment_bounds.shape.extents = Vector2(regiment_unit_size.y * unit_pixel_size /2  ,regiment_unit_size.z * unit_pixel_size /2  )
	hitbox_rotation.shape.radius = unit_pixel_size
	hitbox_polygone.polygon = get_front_arc_polygon()
	update_relatives()
	update_attached_gui()

func get_front_arc_polygon():
	#shrott, noch missverstanden
	var bounds = hitbox_regiment_bounds.shape.extents
	var left_bot = Vector2(-bounds.x, - bounds.y) + position
	var right_bot = Vector2(bounds.x, - bounds.y) + position
	var left_top =  left_bot + Vector2.UP.rotated(deg_to_rad(-45) * 100)
	var right_top = right_bot + Vector2.UP.rotated(deg_to_rad(45))
	return PackedVector2Array([left_bot,left_top,right_top, right_bot])

func _input(event):
	#selection reset
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
			if selected:
				selected = false
			if has_selected_rotation:
				has_selected_rotation = false

func _process(delta):
	check_if_runtime_ini()
	queue_redraw()

func _physics_process(delta):
	if selected:
		handleDragnDropMovement(delta)
	elif has_selected_rotation:
		handleDragnDropRotation(delta)

func setup(setup_facing : Vector2, setup_position : Vector2):
	self.setup_facing_dir = setup_facing
	self.setup_pos = setup_position
	if setup_facing == Vector2.DOWN:
		rotation_degrees += 180

func setup_regiment(pos : Vector2):
	position +=pos
	hitbox_polygone.polygon = get_front_arc_polygon()
	setup_units()

func setup_units():
	var offset = Vector2(unit_pixel_size/2,unit_pixel_size/2)
	for n in regiment_unit_size.x:		
		var unit = faction_unit_preload.instantiate()
		unit.setup(Vector2(1,7))
		unit.unit_name = "Soldat " + str(n)
		var collum =  floor(n / regiment_unit_size.y)
		unit.position = relative_position + Vector2(n * unit_pixel_size - collum * regiment_unit_size.y * unit_pixel_size , collum * unit_pixel_size ) + offset
		add_child(unit)
		faction_units.append(unit)

func update_attached_gui():
	var y_offset =  -(regiment_unit_size.z * 24)
	for node in node_to_update:
		node.position += Vector2(0,y_offset)
		
func update_relatives():
	shape_extends_total = Vector2(hitbox_regiment_bounds.shape.extents.x *2, hitbox_regiment_bounds.shape.extents.y *2)
	relative_position = Vector2(position.x - shape_extends_total.x / 2.0, position.y - shape_extends_total.y / 2.0)
	regiment_bounds =  Rect2(relative_position,shape_extends_total)	

func handleDragnDropMovement(delta):
	var action_points = move()

func handleDragnDropRotation(delta):
	var action_points =	rotate_dragged_object(delta)

func rotate_dragged_object(delta):
	var direction = get_global_mouse_position() - global_position
	var alpha = Vector2.UP.rotated(rotation).angle_to(direction)
	global_rotation += alpha
	return alpha

func check_if_runtime_ini():
	if isIni && setup_pos != Vector2.ZERO:
		isIni = false
		setup_regiment(setup_pos)

func _draw():
	draw_rect(regiment_bounds,Color.WHEAT,true, -1.0)
	draw_circle(hitbox_rotation.position,hitbox_rotation.shape.radius,Color(0.5, 0.5, 0.5, 0.5 ))
	draw_colored_polygon(hitbox_polygone.polygon,Color(0.7, 0.5, 0.5, 0.5 ))

func rotateTo(aGlobalPosition):
	var direction = aGlobalPosition - global_position
	var alpha = Vector2.UP.rotated(rotation).angle_to(direction)
	global_rotation += alpha

func move():
		var dragVector = get_global_mouse_position() - selected_Mouse_Position
		var rotadetForward = Vector2.UP.rotated(rotation)		
		var dot = rotadetForward.dot(dragVector)
			
		if selected and dot > 0:
			global_position += rotadetForward * dot
			selected_Mouse_Position = get_global_mouse_position()
			return abs(dot)
		elif selected and dot < 0:
			var rotatedBack = Vector2.DOWN.rotated(rotation)
			global_position -= rotatedBack * dot
			selected_Mouse_Position = get_global_mouse_position()
			return abs(dot)
			
		
		return 0
	
func _on_hitbox_rotation_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("left_click"):
		has_selected_rotation = true
		selected = false
		selected_Mouse_Position = get_global_mouse_position()

func _on_hitbox_regiment_bounds_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("left_click"):
		selected = true
		has_selected_rotation = false
		selected_Mouse_Position = get_global_mouse_position()
