extends Node2D

var regiment : FactionRegiment

func _ready():
	regiment = get_parent()

func _process(delta):
	queue_redraw()

func _draw():
	#draw_front_arc()
	pass

func draw_front_arc():
	#nur zur entwicklung um hitboxen anzupassen
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
	
func draw_regiment_45_line_arcs():
	# Testlinien zeichnen
	var size = regiment.get_current_bounds_extends() as Vector2
	draw_dashed_line(position,Vector2.UP.rotated(rotation) * 250 ,Color.WEB_GREEN, 8.0, 2.0, true )
	var rotation_off = 0.5 as float
	var lowerRight = Vector2(size.x ,size.y)
	draw_dashed_line(position + lowerRight,lowerRight + Vector2.RIGHT.rotated(rotation + rotation_off) * 250 ,Color.WEB_GREEN, 8.0, 2.0, true )
	
	var upRight = Vector2(size.x ,-size.y)
	draw_dashed_line(position + upRight,upRight + Vector2.RIGHT.rotated(rotation - rotation_off) * 250 ,Color.WEB_GREEN, 8.0, 2.0, true )
	
	var lowLeft = Vector2(-size.x ,size.y)
	draw_dashed_line(position + lowLeft,lowLeft + Vector2.LEFT.rotated(rotation - rotation_off) * 250 ,Color.WEB_GREEN, 8.0, 2.0, true
	 )
	var upLeft = Vector2(-size.x ,-size.y)
	draw_dashed_line(position + upLeft,upLeft + Vector2.LEFT.rotated(rotation + rotation_off) * 250 ,Color.WEB_GREEN, 8.0, 2.0, true )
