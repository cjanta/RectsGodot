extends Area2D



var regiment : Faction_Regiment
@onready var coll_shape :CollisionPolygon2D = $front_arc

func _ready():
	regiment = get_parent()
	coll_shape.polygon = get_regiment_front_polygon()
	
	pass

func get_regiment_front_polygon():
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
	return points

func draw_front_arc():
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
