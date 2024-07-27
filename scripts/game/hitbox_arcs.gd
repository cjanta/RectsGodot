class_name Hitbox_Arcs

extends Area2D
@onready var coll_shape :CollisionPolygon2D = $CollisionPolygon2D
var is_runtime_ini = true
var regiment : Faction_Regiment
const RED = Color(1.0, 0, 0, 0.05)
const GREEN = Color(0, 1.0, 0, 0.05)
var draw_color = GREEN

var packed_front_arc :PackedVector2Array
var packed_right_arc :PackedVector2Array
var packed_back_arc : PackedVector2Array
var packed_left_arc :PackedVector2Array

var top_left : Vector2
var bot_left : Vector2
var top_right : Vector2
var bot_right : Vector2

var is_draw_arc = true

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
	var size = regiment.get_current_bounds_extends() as Vector2
	top_left =  position + Vector2(-size.x ,-size.y)
	bot_left =  position + Vector2(-size.x ,size.y)
	top_right = position + Vector2(size.x ,-size.y)
	bot_right = position + Vector2(size.x ,size.y)

func _draw():
	#for chargeable_regiment : Faction_Regiment in chargeable_regiments:
		#if regiment.is_session_selected_regiment():		
			#draw_line(position ,to_local(chargeable_regiment.global_position) , Color.REBECCA_PURPLE, 8.0 , true)
			#var other_chargeables : Array[Faction_Regiment] = chargeable_regiment.hitbox_arcs_node.chargeable_regiments
			#for reg in other_chargeables:
				#if reg == regiment:
					#var off = Vector2(8,0)
					#draw_line(position +off,to_local(chargeable_regiment.global_position)+off , Color.INDIAN_RED, 8.0 , true)
	if not is_runtime_ini && is_draw_arc:
		var range = regiment.type.action_points
		var range_halfed = range / 2.0
		var temp_arc = get_any_tabletop_arc(top_left,Vector2.UP,top_right,Vector2.RIGHT, range )
		draw_polygon(temp_arc, PackedColorArray([draw_color]))
		temp_arc = get_any_tabletop_arc(top_right,Vector2.RIGHT,bot_right,Vector2.DOWN, range_halfed )
		draw_polygon(temp_arc, PackedColorArray([draw_color]))
		temp_arc = get_any_tabletop_arc(bot_right,Vector2.DOWN,bot_left,Vector2.LEFT, range_halfed )
		draw_polygon(temp_arc, PackedColorArray([draw_color]))	
		temp_arc = get_any_tabletop_arc(bot_left,Vector2.LEFT,top_left,Vector2.UP, range_halfed )
		draw_polygon(temp_arc, PackedColorArray([draw_color]))
		
		#draw_polygon(get_arc_point(-90), PackedColorArray([Color.AQUA]))
		
		#draw_polygon(packed_left_arc, PackedColorArray([draw_color]))
		#draw_polygon(packed_back_arc, PackedColorArray([draw_color]))
		draw_line(top_left,top_left + Vector2.UP.rotated(deg_to_rad(-45)) * range ,Color.GRAY,3,true)
		draw_line(bot_left,bot_left + Vector2.LEFT.rotated(deg_to_rad(-45)) * range_halfed ,Color.GRAY,3,true)
		draw_line(top_right,top_right + Vector2.RIGHT.rotated(deg_to_rad(-45)) * range ,Color.GRAY,3,true)
		draw_line(bot_right,bot_right + Vector2.DOWN.rotated(deg_to_rad(-45)) * range_halfed ,Color.GRAY,3,true)

func _on_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	var other_regiment = area.get_parent() as Faction_Regiment
	if  other_regiment != null and other_regiment != regiment:
		draw_color = RED

func _on_area_shape_exited(area_rid, area, area_shape_index, local_shape_index):
	var other_regiment = area.get_parent() as Faction_Regiment
	if  other_regiment != null and other_regiment != regiment:
		draw_color = GREEN

func get_tabletop_front_arc():
	var points_arc = PackedVector2Array()
	var range = 128
	points_arc.push_back(top_left)
	points_arc.push_back(top_left + Vector2.UP.rotated(deg_to_rad(-45)) * range )
	points_arc.push_back(top_right + Vector2.UP.rotated(deg_to_rad(45)) * range )
	points_arc.push_back(top_right)
	return points_arc

func get_any_tabletop_arc(from_base : Vector2,from_direction : Vector2, to_base : Vector2, to_direction : Vector2, range : float):
	var points_arc = PackedVector2Array()
	points_arc.push_back(from_base)
	points_arc.push_back(from_base + from_direction.rotated(deg_to_rad(-45)) * range )
	points_arc.push_back(to_base + to_direction.rotated(deg_to_rad(-45)) * range )
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
