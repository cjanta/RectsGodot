extends Area2D


var is_runtime_ini = true
var regiment : Faction_Regiment
@onready var coll_shape :CollisionPolygon2D = $CollisionPolygon2D

func _ready():
	regiment = get_parent()
	coll_shape.polygon = coll_shape.polygon.duplicate()
		
	pass

func _process(delta):
	chick_runtime_ini()
	queue_redraw()
	
func chick_runtime_ini():
	if is_runtime_ini:
		is_runtime_ini = false;
		#coll_shape.polygon = get_regiment_front_polygon()
		coll_shape.polygon =get_front_arc()
		

const DETECT_RADIUS = 200
const FOV = 80

var angle = 0
var direction = Vector2()
# Drawing the FOV
const RED = Color(1.0, 0, 0, 0.4)
const GREEN = Color(0, 1.0, 0, 0.4)

var draw_color = GREEN

func _draw():
	#draw_circle_arc_poly(Vector2(), DETECT_RADIUS,  angle - FOV/2, angle + FOV/2, draw_color)
	pass

func get_front_arc():
	var size = regiment.get_current_bounds_extends() as Vector2
	var angle = -90
	var center = Vector2.ZERO
	var tl = position + Vector2(-size.x ,-size.y)
	var tr = position + Vector2(size.x ,-size.y)
	var fow = rad_to_deg(tl.angle_to(tr))
	var radius = regiment.shape_extends_total.length()
	var angle_from = angle - fow/2
	var angle_to = angle + fow/2
	var nb_points = 16
	var points_arc = PackedVector2Array()
	points_arc.push_back(center)
	#var colors = PackedColorArray([color])

	for i in range(nb_points+1):
		var angle_point = angle_from + i*(angle_to-angle_from)/nb_points
		points_arc.push_back(center + Vector2( cos( deg_to_rad(angle_point) ), sin( deg_to_rad(angle_point) ) ) * radius)
	#draw_polygon(points_arc, colors)
	return points_arc

func draw_circle_arc_poly(center, radius, angle_from, angle_to, color):
	var nb_points = 32
	var points_arc = PackedVector2Array()
	points_arc.push_back(center)
	var colors = PackedColorArray([color])

	for i in range(nb_points+1):
		var angle_point = angle_from + i*(angle_to-angle_from)/nb_points
		points_arc.push_back(center + Vector2( cos( deg_to_rad(angle_point) ), sin( deg_to_rad(angle_point) ) ) * radius)
	draw_polygon(points_arc, colors)

func draw_front_arc_flat():
	var size = regiment.get_current_bounds_extends() as Vector2
	var rotation_off = deg_to_rad(60)
	var arc_length = 180
	#[tl, tl_arc, tr_arc, tr]
	var points = PackedVector2Array()
	var tl = position + Vector2(-size.x ,-size.y)
	points.append(tl)
	var tl_arc = Vector2(-size.x ,-size.y) + Vector2.LEFT.rotated(rotation + rotation_off) * arc_length
	points.append(tl_arc)
	var tr_arc = Vector2(size.x ,-size.y) + Vector2.RIGHT.rotated(rotation - rotation_off) * arc_length	
	points.append(tr_arc)
	var tr = position + Vector2(size.x ,-size.y)
	points.append(tr)

	var color = Color(25,25,25,64)
	var colors = PackedColorArray([color])
	var uvs = PackedVector2Array()
	draw_polygon(points, colors,uvs,null)
