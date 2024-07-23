class_name Faction_Regiment
extends Node2D

@export var faction_units : Array[Faction_Unit] = []
@export var setup_facing_dir : Vector2 = Vector2.ZERO
@export var setup_pos : Vector2 = Vector2.ZERO
@onready var hitbox_arcs_node = $hitbox_arcs

var session : Game_Session
var faction : Faction
var faction_unit_preload
var is_runntime_ini = true
var is_Selectable = false:
	set(value):
		is_Selectable = value
	get:
		return is_Selectable

var type : Regiment_Type

signal update_visuals(current_bounds_extends)

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
	setup_facing_dir = type.setup_facing_dir
	if setup_facing_dir == Vector2.DOWN:
		rotation_degrees += 180
	setup_pos = type.setup_position
	set_regiment_unit_size(type.regiment_unit_size)
	
	pass
	
func runntime_ini():
	update_relatives()
	update_visuals.emit(current_bounds_extends)
	position += setup_pos
	var offset = Vector2(unit_pixel_size/2, unit_pixel_size/2)
	for n in regiment_unit_size.x:		
		var unit = faction_unit_preload.instantiate()
		var collum =  floor(n / regiment_unit_size.y)
		unit.position = relative_position  + Vector2(n * unit_pixel_size - collum * regiment_unit_size.y * unit_pixel_size , collum * unit_pixel_size ) + offset
		add_child(unit)
		faction_units.append(unit)
	guilog(get_rich_common_prefix() + " mit " + str(faction_units.size()) + " Einheiten bereit.")

func update_relatives():
	shape_extends_total = Vector2(current_bounds_extends.x * 2, current_bounds_extends.y *2)
	relative_position = Vector2(position.x - shape_extends_total.x / 2.0, position.y - shape_extends_total.y / 2.0)
	regiment_bounds =  Rect2(relative_position,shape_extends_total)		

func check_if_runtime_ini():
	if is_runntime_ini:
		is_runntime_ini = false
		runntime_ini()

func get_rich_display_prefix():
	var faction_prefix = faction.get_rich_logPrefix()
	var message = faction_prefix + "\n"
	message += "\t" + type.regiment_name + "\n"
	message += "\t" + "Lebende " + str(faction_units.size()) + "\n"
	message += "\t" + "AP " + str(type.action_points)
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
	session.update_selection_display(self as Faction_Regiment)
	
func session_set_selected_regiment():
	session.set_selected_regiment(self as Faction_Regiment)
	
func session_clear_selected_regiment():
	session.remove_selected_regiment(self as Faction_Regiment)
	
func is_session_selected_regiment():
	return session.is_selected_regiment(self as Faction_Regiment)
	
	
	
	
	
	
	
