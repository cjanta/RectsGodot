extends Area2D

@onready var coll_shape :CollisionPolygon2D = $CollisionPolygon2D
var is_runtime_ini = true
var regiment : Faction_Regiment
const RED = Color(1.0, 0, 0, 0.05)
const GREEN = Color(0, 1.0, 0, 0.05)
var draw_color = GREEN
var test_draw_color_front = Color.WHITE_SMOKE
var test_draw_color_back = Color.BLACK
var test_draw_color_right = Color.YELLOW
var test_draw_color_left = Color.ORANGE

var packed_front_arc :PackedVector2Array
var packed_right_arc :PackedVector2Array
var packed_back_arc : PackedVector2Array
var packed_left_arc :PackedVector2Array
var is_draw_arc = true

var chargeable_regiments : Array[Faction_Regiment]

func _ready():
	regiment = get_parent()
	coll_shape.polygon = coll_shape.polygon.duplicate()		

func _process(delta):
	check_runtime_ini()
	queue_redraw()

func check_runtime_ini():
	if is_runtime_ini:
		is_runtime_ini = false;
		update_arcs()
		

func _draw():
	#Todo: Bug, positionen von oben ziehen line in falsche Richtung
	for regiment in chargeable_regiments:
		var target_pos = position + (regiment.global_position - global_position) 
		draw_line(position, target_pos, Color.AQUA, 8.0 , true)
	#var test_draw_color_front = Color.WHITE_SMOKE
	#var test_draw_color_back = Color.BLACK
	#var test_draw_color_right = Color.YELLOW
	#var test_draw_color_left = Color.ORANGE
	if not is_runtime_ini && is_draw_arc:
		draw_polygon(packed_front_arc, PackedColorArray([draw_color]))
		#draw_polygon(packed_right_arc, PackedColorArray([draw_color]))
		#draw_polygon(packed_left_arc, PackedColorArray([draw_color]))
		#draw_polygon(packed_back_arc, PackedColorArray([draw_color]))

func get_arc_point(angle_degrees):
	var size = regiment.get_current_bounds_extends() as Vector2
	var angle = angle_degrees
	var center = Vector2.ZERO
	var fow =get_fov_of_degrees(angle_degrees)
	var radius = size.length() + 4.0
	var angle_from = angle - fow/2
	var angle_to = angle + fow/2
	var nb_points = 16
	var points_arc = PackedVector2Array()
	points_arc.push_back(center)

	for i in range(nb_points+1):
		var angle_point = angle_from + i*(angle_to-angle_from)/nb_points
		points_arc.push_back(center + Vector2( cos( deg_to_rad(angle_point) ), sin( deg_to_rad(angle_point) ) ) * radius)
	return points_arc

func get_fov_of_degrees(angle_degrees):
	var size = regiment.get_current_bounds_extends() as Vector2
	if(angle_degrees == -90): #front
		var tl = position + Vector2(-size.x ,-size.y)
		var tr = position + Vector2(size.x ,-size.y)
		return rad_to_deg(tl.angle_to(tr))
	elif(angle_degrees == 90): #back
		var dl = position + Vector2(-size.x ,size.y)
		var dr = position + Vector2(size.x ,size.y)
		return rad_to_deg(dl.angle_to(dr))
	elif(angle_degrees == 0): #right
		var tr = position + Vector2(size.x ,-size.y)
		var dr = position + Vector2(size.x ,size.y)
		return rad_to_deg(tr.angle_to(dr))
	elif(angle_degrees == 180): #left
		var tl = position + Vector2(-size.x ,-size.y)
		var dl = position + Vector2(-size.x ,size.y)
		return rad_to_deg(tl.angle_to(dl))	

func _on_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	var other_regiment = area.get_parent() as Faction_Regiment
	if  other_regiment != null and other_regiment != regiment:
		draw_color = RED
		if other_regiment == simple_raycast(other_regiment.global_position):
			chargeable_regiments.append(other_regiment)

func _on_area_shape_exited(area_rid, area, area_shape_index, local_shape_index):
	var other_regiment = area.get_parent() as Faction_Regiment
	if  other_regiment != null and other_regiment != regiment:
		draw_color = GREEN
		chargeable_regiments.remove_at(chargeable_regiments.find(other_regiment,0))

func _on_faction_regiment_scene_update_visuals(current_bounds_extends):
	update_arcs()

func update_arcs():
	packed_front_arc = get_arc_point(-90)
	coll_shape.polygon = packed_front_arc
	packed_right_arc = get_arc_point(0)
	packed_back_arc = get_arc_point(90)
	packed_left_arc = get_arc_point(180)

func simple_raycast(target_global_position : Vector2):
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(global_position, target_global_position, collision_layer)
	query.collide_with_areas = true
	query.exclude = [self]
	var result : Dictionary = space_state.intersect_ray(query)
	if not result.is_empty():
		return	result.collider.get_parent()
	return null
