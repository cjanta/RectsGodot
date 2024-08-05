class_name Faction
extends Node2D

@export var faction_name : String = "muster_faction_name"
@export var faction_texture : Texture2D
@export var owner_ident : String = "LOCAL_PLAYER"
@export var start_direction : Vector2 = Vector2.ZERO
@export var faction_regiments : Array[FactionRegiment] = []
@onready var regiments_preload
var session : GameSession
var sum_regiments = 0
var faction_type : FactionType
var army_book : ArmyBook
var faction_color : Color
var faction_color_html = Color.WHITE.to_html()

func setup(type):
	faction_type = type
	army_book = type.army_book
	faction_name = type.faction_name
	start_direction = type.start_facing
	faction_texture = type.faction_texture
	faction_color = type.faction_color
	faction_color_html = faction_color.to_html()

func _ready():
	session = find_parent("Game_Session")
	regiments_preload = load("res://scns/game/faction_regiment_scene.tscn")
	var x_offset = Vector2(500,200)
	var num_per_faction = 2
	var window_size = DisplayServer.window_get_size()
	if start_direction == Vector2.DOWN:
		for n in num_per_faction:
			sum_regiments += 1
			create_test_regiments(Vector2(x_offset.x + n*500, x_offset.y))
	elif start_direction == Vector2.UP:
		for n in num_per_faction:
			sum_regiments += 1
			create_test_regiments(Vector2(x_offset.x + n*750, window_size.y - x_offset.y))

func _process(delta):
	pass
	
func create_test_regiments(start_position : Vector2):
	var regiment : FactionRegiment = regiments_preload.instantiate()
	add_child(regiment)
	randomize()
	var number_units = randi_range(10,101)
	var new_type : RegimentType = army_book.get_random_regiment_type(ArmyBook.ARMY_BOOKS.EMPIRE)
	new_type.setup_facing_dir = start_direction
	new_type.setup_position = start_position
	regiment.set_type(new_type)
	faction_regiments.append(regiment)

func get_rich_logPrefix():
	var color = faction_type.faction_color
	return "[color=" + color.to_html(true) + "]" + faction_type.faction_name + "[/color]"

func guilog(test : String):
	session.gui.log(test)
