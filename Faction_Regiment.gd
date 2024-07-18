class_name Faction_Regiment
extends Node2D

var session : Game_Session
var faction : Faction
var regiment_name : String = ""

var faction_unit_preload = preload("res://faction_unit.tscn")
var is_runntime_ini = true

@export var faction_units : Array[Faction_Unit] = []
@export var setup_facing_dir : Vector2 = Vector2.ZERO
@export var setup_pos : Vector2 = Vector2.ZERO

@onready var hitbox_regiment_bounds = $hitbox_regiment_bounds
@onready var bounds_sprite = $bounds_sprite
@onready var hitbox_rotation : Regiment_rotation = $hitbox_rotation

var shape_extends_total = Vector2.ZERO # full width and height
var current_bounds_extends = Vector2.ZERO #ready to shape, halfed
var	relative_position = Vector2.ZERO
var	regiment_bounds =  null
var regiment_unit_size = Vector3(3,1,3)
var unit_pixel_size = 32.0


func _ready():
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

func setup(new_name : String, setup_facing : Vector2, setup_position : Vector2, new_size : Vector3):
	self.setup_facing_dir = setup_facing
	regiment_name = new_name
	if setup_facing == Vector2.DOWN:
		rotation_degrees += 180
	self.setup_pos = setup_position
	set_regiment_unit_size(new_size)
	
func runntime_ini():
	update_relatives()
	hitbox_regiment_bounds.update_extends(current_bounds_extends)
	bounds_sprite.update_scale(current_bounds_extends)
	hitbox_rotation.update_position(current_bounds_extends)
	position += setup_pos
	var offset = Vector2(unit_pixel_size/2, unit_pixel_size/2)
	for n in regiment_unit_size.x:		
		var unit = faction_unit_preload.instantiate()
		var collum =  floor(n / regiment_unit_size.y)
		unit.position = relative_position  + Vector2(n * unit_pixel_size - collum * regiment_unit_size.y * unit_pixel_size , collum * unit_pixel_size ) + offset
		add_child(unit)
		faction_units.append(unit)
	guilog(faction.faction_name + ": " +  regiment_name + " mit " + str(faction_units.size()) + " Einheiten bereit.")

func update_relatives():
	shape_extends_total = Vector2(current_bounds_extends.x * 2, current_bounds_extends.y *2)
	relative_position = Vector2(position.x - shape_extends_total.x / 2.0, position.y - shape_extends_total.y / 2.0)
	regiment_bounds =  Rect2(relative_position,shape_extends_total)		

func check_if_runtime_ini():
	if is_runntime_ini:
		is_runntime_ini = false
		runntime_ini()

func guilog(text : String):
	session.gui.log(text)
