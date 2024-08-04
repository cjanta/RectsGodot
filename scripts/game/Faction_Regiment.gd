class_name FactionRegiment
extends Node2D

signal update_visuals(current_bounds_extends)

const GREY = Color(1.0, 1.0, 1.0, 0.1)

@export var bounds_sprite : Sprite2D
@export var units_visible = true
@export var bounds_sprite_visible = false

var faction_units : Array[FactionUnit] = []
var session : GameSession
var faction : Faction
var faction_unit_preload
var is_runntime_ini = true
var is_Selectable = false:
	set(value):
		is_Selectable = value
	get:
		return is_Selectable
var type : Regiment_Type


var shape_extends_total = Vector2.ZERO # full width and height
var current_bounds_extends = Vector2.ZERO #ready to shape, halfed
var	relative_position = Vector2.ZERO
var	regiment_bounds =  null
var regiment_unit_size = Vector3(3,1,3)
var unit_pixel_size = 32.0

func _ready():
	faction_unit_preload = load("res://scns/game/faction_unit.tscn")
	session = find_parent("Game_Session")
	faction = get_parent()
	bounds_sprite.visible = bounds_sprite_visible

func get_top_rotated():
	return position - Vector2(0,current_bounds_extends.y).rotated(rotation)

func get_bot_rotated():
	return position - Vector2(0,-current_bounds_extends.y).rotated(rotation)

func get_left_rotated():
	return position - Vector2(current_bounds_extends.x,0).rotated(rotation)

func get_right_rotated():
	return position - Vector2(-current_bounds_extends.x,0).rotated(rotation)

func get_current_bounds_extends():
	return current_bounds_extends

func get_unit_Pixel_size():
	return unit_pixel_size

func set_regiment_unit_size(new_size : Vector3):
	regiment_unit_size = new_size
	update_current_bounds_extends()

func update_current_bounds_extends():
	regiment_unit_size.z = ceil(regiment_unit_size.x / regiment_unit_size.y)
	current_bounds_extends = Vector2(regiment_unit_size.y * unit_pixel_size /2  ,regiment_unit_size.z * unit_pixel_size /2  )

func _process(delta):
	check_if_runtime_ini()

func set_type(regiment_type : Regiment_Type):
	type = regiment_type
	type.regiment_texture = faction.faction_texture
	var setup_facing_dir = type.setup_facing_dir
	rotation_degrees = rad_to_deg(setup_facing_dir.angle_to(Vector2.UP))
	set_regiment_unit_size(type.regiment_unit_size)
	
func runntime_ini():
	update_relatives()
	update_visuals.emit(current_bounds_extends)
	position += type.setup_position
	var offset = Vector2(unit_pixel_size/2, unit_pixel_size/2)
	for n in regiment_unit_size.x:		
		var unit = faction_unit_preload.instantiate()
		var collum =  floor(n / regiment_unit_size.y)
		unit.position = relative_position  + Vector2(n * unit_pixel_size - collum * regiment_unit_size.y * unit_pixel_size , collum * unit_pixel_size ) + offset
		unit.visible = units_visible
		add_child(unit)
		faction_units.append(unit)
		var setup_facing_dir = type.setup_facing_dir
		var angle = setup_facing_dir.angle_to(Vector2.UP)
		unit.rotation = angle
		if abs(rad_to_deg(angle)) > 90:
			unit.sprite_flipped_vert = true
	var message = get_rich_common_prefix() + " mit " + str(faction_units.size()) + " Einheiten bereit."
	log_with_bg_color(message)

func log_with_bg_color(text):	
	var col_html = Color(0.5, 0.5, 0.5, 0.25).to_html()
	guilog("[bgcolor=" + col_html + "]" + text + "[/bgcolor]")

func log_links():
	#Temp. Beispiel, Verzweigung impl in 
	guilog("[url=print]Google[/url] or [url=quit]Quit to Desktop[/url].")

func add_regiment_rotation(angle):
	global_rotation += angle
	var abs_rot = abs(global_rotation_degrees)
	for u in faction_units:
		if not u.sprite_flipped_vert and abs_rot > 90:
			u.flip_sprite_vertical()
		elif u.sprite_flipped_vert and abs_rot <= 90:
			u.flip_sprite_vertical()

func update_relatives():
	shape_extends_total = Vector2(current_bounds_extends.x * 2, current_bounds_extends.y *2)
	relative_position = Vector2(position.x - shape_extends_total.x / 2.0, position.y - shape_extends_total.y / 2.0)
	regiment_bounds =  Rect2(relative_position,shape_extends_total)		

func check_if_runtime_ini():
	if is_runntime_ini:
		is_runntime_ini = false
		runntime_ini()

func get_rich_display_prefix():
	var dead_icon = "[img]" + "res://grfx/icon_Skull32.png" + "[/img]"
	var faction_prefix = faction.get_rich_logPrefix()
	var info_size = str(faction_units.size())
	var info_died = str(regiment_unit_size.x - faction_units.size())
	var message = ""
	message += "\t" + info_size + " " + type.regiment_name + "\n"
	message += "\t"+ dead_icon + "" + info_died + " " + type.regiment_name + "\n"
	message += "\t" + "AP " + str(snapped(type.action_points, 0.01))
	return get_colored_string(message, Color.WHEAT)

func get_rich_common_prefix():
	var faction_prefix = faction.get_rich_logPrefix()
	return faction_prefix + " " + get_colored_string(type.regiment_name, Color.WHEAT)

func get_colored_string(message : String, color : Color):
	var html_color = color.to_html(true)
	var prefix = "[color=" + html_color + "]"
	var suffix = "[/color]"
	return prefix + message + suffix

func guilog(text : String):
	session.gui.log(text)

func _on_hitbox_regiment_bounds_selection_changed(has_selected_movement):
	if has_selected_movement:
		session_set_selected_regiment()
	
func _on_hitbox_rotation_selection_changed(has_selected_rotation):
	if has_selected_rotation:
		session_set_selected_regiment()
		
func session_update_selection_display():
	session.update_selection_display(self as FactionRegiment)
	
func session_set_selected_regiment():
	session.set_selected_regiment(self as FactionRegiment)
	
func session_clear_selected_regiment():
	session.remove_selected_regiment(self as FactionRegiment)
	
func is_session_selected_regiment():
	return session.is_selected_regiment(self as FactionRegiment)
	
	
	
	
	
	
	
