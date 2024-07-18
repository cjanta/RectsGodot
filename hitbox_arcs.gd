extends Area2D

var is_runtime_ini = true
var regiment : Faction_Regiment

@onready var coll_shape :CollisionPolygon2D = $CollisionPolygon2D


func _ready():
	regiment = get_parent()
	coll_shape.polygon = coll_shape.polygon.duplicate()		

func _process(delta):
	check_runtime_ini()
	queue_redraw()

func check_runtime_ini():
	if is_runtime_ini:
		is_runtime_ini = false;
		coll_shape.polygon = get_front_arc()
		

const RED = Color(1.0, 0, 0, 0.4)
const GREEN = Color(0, 1.0, 0, 0.4)
var draw_color = GREEN

func _draw():
	draw_front_arc()

func draw_front_arc():
	var front_arc = get_front_arc()
	draw_polygon(front_arc, PackedColorArray([draw_color]))

func get_front_arc():	
	var size = regiment.get_current_bounds_extends() as Vector2
	var angle = -90
	var center = Vector2.ZERO
	var tl = position + Vector2(-size.x ,-size.y)
	var tr = position + Vector2(size.x ,-size.y)
	var fow = rad_to_deg(tl.angle_to(tr))
	var radius = regiment.shape_extends_total.length() / 2.0
	var angle_from = angle - fow/2
	var angle_to = angle + fow/2
	var nb_points = 16
	var points_arc = PackedVector2Array()
	points_arc.push_back(center)

	for i in range(nb_points+1):
		var angle_point = angle_from + i*(angle_to-angle_from)/nb_points
		points_arc.push_back(center + Vector2( cos( deg_to_rad(angle_point) ), sin( deg_to_rad(angle_point) ) ) * radius)
	return points_arc


func _on_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	if area.get_parent() != regiment:
		draw_color = RED


func _on_area_shape_exited(area_rid, area, area_shape_index, local_shape_index):
	if area.get_parent() != regiment:
		draw_color = GREEN
