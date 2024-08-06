class_name HitboxArcs
extends Area2D

@export var coll_shape :CollisionPolygon2D

@onready var info_label_preload  = load("res://scns/game/info_label.tscn")

var is_runtime_ini = true
var regiment : FactionRegiment
const RED = Color(1.0, 0, 0, 0.1)
const GREEN = Color(0, 1.0, 0, 0.1)
var draw_color = GREEN
const GREY = Color(1.0, 1.0, 1.0, 0.1)

var packed_front_arc :PackedVector2Array
var packed_right_arc :PackedVector2Array
var packed_back_arc : PackedVector2Array
var packed_left_arc :PackedVector2Array

var top : Vector2
var top_left : Vector2
var top_right : Vector2
var bot : Vector2
var bot_left : Vector2
var bot_right : Vector2
var left : Vector2
var right : Vector2
var size_extends : Vector2

var is_draw_arc = true

var front_fov_enemies : Array[FactionRegiment]
var infoLabels : Array[InfoLabel]

func _ready():
	regiment = get_parent()
	coll_shape.polygon = coll_shape.polygon.duplicate()		

func _process(delta):
	check_runtime_ini()
	queue_redraw()

func check_runtime_ini():
	if is_runtime_ini:
		is_runtime_ini = false;
		update_metrics()
		update_arcs()

func update_arcs():
	#packed_front_arc = get_arc_point(-90)
	packed_front_arc = get_tabletop_front_arc()
	coll_shape.polygon = packed_front_arc
	packed_right_arc = get_arc_point(0)
	packed_back_arc = get_arc_point(90)
	packed_left_arc = get_arc_point(180)

func _on_faction_regiment_scene_update_visuals(current_bounds_extends):
	update_metrics()
	update_arcs()

func update_metrics():
	size_extends = regiment.get_current_bounds_extends() as Vector2
	top = position + Vector2(0 ,-size_extends.y)
	bot = position + Vector2(0 ,size_extends.y)
	left = position + Vector2(-size_extends.x,0)
	right = position + Vector2(size_extends.x,0)
	top_left =  position + Vector2(-size_extends.x ,-size_extends.y)
	bot_left =  position + Vector2(-size_extends.x ,size_extends.y)
	top_right = position + Vector2(size_extends.x ,-size_extends.y)
	bot_right = position + Vector2(size_extends.x ,size_extends.y)

func is_regiment_in_front_arc(enemy_regiment : FactionRegiment):
	return front_fov_enemies.find(enemy_regiment,0) != -1

func _draw():
	if not is_runtime_ini && is_draw_arc:
		if regiment.is_session_selected_regiment():
			draw_diagonal_lines()
			draw_distance_lines()
		else:
			if not infoLabels.is_empty():
				hide_info_labels()
		
func draw_distance_lines():
	var other_faction : Faction = regiment.faction.session.get_other_faction(regiment)
	hide_info_labels()		
	for reg : FactionRegiment in front_fov_enemies:
		draw_labeld_line_to_target(reg)

func draw_labeld_line_to_target(target_regiment : FactionRegiment):
	#var target =  to_local(reg.get_top_rotated())
	var color = RED
	var target = find_closest_target(target_regiment)
	var dir = target - top
	var dir_length = dir.length()	
	var new_label = get_free_info_label()
	new_label.rotation = top.angle_to(dir)
	new_label.position = top + dir.normalized()  * dir_length / 2.0 - new_label.get_center()
	new_label.visible = true
	new_label.text = str(floor(dir_length))	
	var charge_range = target_regiment.type.charge_range
	if dir_length <= charge_range:
		color = GREEN
	draw_line(top, target , color, 3.0, true)

func get_attackable(target_regiment : FactionRegiment):
	var result = []
	var isIn = is_regiment_in_front_arc(target_regiment)
	if isIn:
		var target = find_closest_target(target_regiment)
		var dir = target - top
		var dir_length = dir.length()
		if dir_length <= target_regiment.type.charge_range:
			return [target]
			
	return result

func find_closest_target(reg : FactionRegiment):
	var points_lenghts = []	
	
	var target =  to_local(reg.get_top_rotated())
	var dir = target - top
	points_lenghts.append(dir.length())
	
	target =  to_local(reg.get_bot_rotated())
	dir = target - top
	points_lenghts.append(dir.length())
	
	target =  to_local(reg.get_left_rotated())
	dir = target - top
	points_lenghts.append(dir.length())
	
	target =  to_local(reg.get_right_rotated())
	dir = target - top
	points_lenghts.append(dir.length())
	
	var closest = dir.length()
	var p_closest = 3
	for i in 4:
		if points_lenghts[i] < closest:
			closest = points_lenghts[i]
			p_closest = i
	if(p_closest == 0):
		return to_local(reg.get_top_rotated())
	elif (p_closest == 1):
		return to_local(reg.get_bot_rotated())
	elif (p_closest == 2):
		return to_local(reg.get_left_rotated())
	elif (p_closest == 3):
		return to_local(reg.get_right_rotated())
	else :
		return Vector2.ZERO

func hide_info_labels():
	for label in infoLabels:
		label.visible = false

func get_free_info_label():
	if infoLabels.is_empty():
		return get_new_info_label()
	else:
		for label in infoLabels:
			if label.visible == false:
				return label
		return get_new_info_label()

func get_new_info_label():
	var new_label = info_label_preload.instantiate()
	infoLabels.append(new_label)
	add_child(new_label)
	return new_label

func draw_diagonal_lines():
	draw_line(top_left,top_left + Vector2.UP.rotated(deg_to_rad(-45)) * 800  ,GREY,3,true)
	draw_line(top_right,top_right + Vector2.RIGHT.rotated(deg_to_rad(-45)) * 800 ,GREY,3,true)
	#
	#draw_line(bot_left,bot_left + Vector2.LEFT.rotated(deg_to_rad(-45)) * 800 ,GREY,3,true)
	#draw_line(bot_right,bot_right + Vector2.DOWN.rotated(deg_to_rad(-45)) * 800 ,Color.GRAY,3,true)

func _on_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	var other_regiment = area.get_parent() as FactionRegiment
	if  other_regiment != null and other_regiment != regiment and other_regiment.faction != regiment.faction:
		draw_color = RED
		front_fov_enemies.append(other_regiment)

func _on_area_shape_exited(area_rid, area, area_shape_index, local_shape_index):
	var other_regiment = area.get_parent() as FactionRegiment
	if  other_regiment != null and other_regiment != regiment:
		draw_color = GREEN
		front_fov_enemies.erase(other_regiment)

func get_tabletop_front_arc():
	var points_arc = PackedVector2Array()
	var range = 800
	points_arc.push_back(top_left)
	points_arc.push_back(top_left + Vector2.UP.rotated(deg_to_rad(-45)) * range )
	points_arc.push_back(top_right + Vector2.UP.rotated(deg_to_rad(45)) * range )
	points_arc.push_back(top_right)
	return points_arc

func get_any_tabletop_arc(from_base : Vector2,from_direction : Vector2, to_base : Vector2, to_direction : Vector2, range : float):
	var points_arc = PackedVector2Array()
	from_direction = from_direction * range
	to_direction = to_direction * range
	points_arc.push_back(from_base)
	points_arc.push_back(from_base + from_direction.rotated(deg_to_rad(-45)) )
	points_arc.push_back(to_base + to_direction.rotated(deg_to_rad(-45)) )
	points_arc.push_back(to_base)
	return points_arc

func simple_raycast(target_global_position : Vector2):
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(global_position, target_global_position, collision_layer)
	query.collide_with_areas = true
	query.exclude = [self]
	var result : Dictionary = space_state.intersect_ray(query)
	if not result.is_empty():
		return	result.collider.get_parent()
	return null

func get_arc_point(angle_degrees):
	var size = regiment.get_current_bounds_extends() as Vector2
	var angle = angle_degrees
	var center = Vector2.ZERO - Vector2(0,size.y)
	#var fow =get_fov_of_degrees(angle_degrees)
	var fow = 180
	var radius = 128
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
