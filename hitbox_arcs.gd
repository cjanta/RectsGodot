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
	
func chick_runtime_ini():
	if is_runtime_ini:
		is_runtime_ini = false;
		coll_shape.polygon = get_regiment_front_polygon()
		
func get_regiment_front_polygon():
	var size = regiment.hitbox_regiment_bounds.shape.extents as Vector2
	var y_offset = regiment.hitbox_regiment_bounds.shape.extents.y + regiment.unit_pixel_size / 2.0
	var rotation_off = deg_to_rad(60)
	var arc_length = 180
	#[tl, tl_arc, tr_arc, tr]
	var points = PackedVector2Array()
	var tl = position + Vector2(-size.x ,-size.y)
	points.append(tl)
	var tl_arc = Vector2(-size.x ,-size.y) + Vector2.LEFT.rotated(rotation + rotation_off) * arc_length
	points.append(tl_arc)
	var tr = position + Vector2(size.x ,-size.y)
	#get_fan_points(tl,tr, tl_arc, points)
	var tr_arc = Vector2(size.x ,-size.y) + Vector2.RIGHT.rotated(rotation - rotation_off) * arc_length	
	points.append(tr_arc)
	points.append(tr)
	return points

func get_fan_points(start : Vector2, end : Vector2, top_left : Vector2, packed_arry : PackedVector2Array):
	var dir = end - start
	var dir_length = dir.length()
	dir = dir.normalized()
	var detail = 1
	var length_ratio = dir_length / detail
	var current = Vector2(start.x,start.y)
	var height = top_left - start
	for n in detail:
		current = current  * length_ratio
		packed_arry.append(Vector2(current.x, current.y).rotated(deg_to_rad(90)))



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
