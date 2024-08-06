class_name FactionRegiment
extends Node2D

signal update_visuals(current_bounds_extends)

const GREY = Color(1.0, 1.0, 1.0, 0.1)

@export var hitbox_arcs : HitboxArcs
@export var hitbox_regiment_bounds : HitboxRegimentBounds
@export var bounds_sprite : Sprite2D
@export var units_visible = true
@export var bounds_sprite_visible = false

var faction_units : Array[FactionUnit] = []
var session : GameSession
var faction : Faction
var regiment_battles : Array[RegimentBattle]
var faction_unit_preload
var is_runntime_ini = true
var is_Selectable = false:
	set(value):
		is_Selectable = value
		if value == false:
			target_regiment = null
			if is_session_selected_regiment():
				session_clear_selected_regiment()
		else:
			if not regiment_battles.is_empty():
				is_Selectable = false

	get:
		return is_Selectable
var type : RegimentType
var target_regiment : FactionRegiment:
	set(value ):
		target_regiment = value
		session.target_selection_display.update(value)
		check_if_attackable(value)


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

func set_regiment_unit_size(new_size : Vector3):
	regiment_unit_size = new_size
	update_current_bounds_extends()

func update_current_bounds_extends():
	
	regiment_unit_size.z = ceil(regiment_unit_size.x / regiment_unit_size.y)
	current_bounds_extends = Vector2(regiment_unit_size.y * unit_pixel_size /2  ,regiment_unit_size.z * unit_pixel_size /2  )

func _process(delta):
	check_if_runtime_ini()

func set_type(regiment_type : RegimentType):
	type = regiment_type
	unit_pixel_size = type.unit_region_data.z
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
	
func is_regiment_in_front_arc(enemie_regiment : FactionRegiment):
	return hitbox_arcs.is_regiment_in_front_arc(enemie_regiment)
	
	
func check_if_attackable(target : FactionRegiment):
	if target == null:
		return

	var result = hitbox_arcs.get_attackable(target) as Array
	if not result.is_empty():
		attack_target_regiment(result, target)
		

func add_battle(new_battle: RegimentBattle):
	add_child(new_battle)
	regiment_battles.append(new_battle)

func attack_target_regiment(result : Array, target : FactionRegiment):
	print("attack: " + target.type.regiment_name)
	var point = result[0] as Vector2
	var target_rotated_forward = Vector2.UP.rotated(target.global_rotation)
	var rotated_forward = Vector2.UP.rotated(global_rotation)
	position = to_global(point)
	var angle_deg = rad_to_deg(target_rotated_forward.angle_to(rotated_forward))
	print(floor(angle_deg))
	angle_deg = abs(angle_deg)
	var angle_of_attack = 0
	if angle_deg <= 45:
		angle_of_attack = 2
	elif angle_deg <= 135:
		angle_of_attack = 1
	else :
		angle_of_attack = 0
	var dir = target.global_position - global_position
	rotation += rotated_forward.angle_to(dir)
	position += Vector2.DOWN.rotated(global_rotation) * current_bounds_extends.y
	var new_battle = RegimentBattle.new()
	new_battle.setup(self, target, global_position, angle_of_attack)
	add_battle(new_battle)
	target.add_battle(new_battle)
	var prefix = get_rich_common_prefix()
	var target_prefix = target.get_rich_common_prefix()
	var message = " attackiert "
	is_Selectable = false
	
	guilog(prefix + message + target_prefix)
	
























