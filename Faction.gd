class_name Faction
extends Node2D

@export var faction_name : String = "muster_faction_name"
@export var owner_ident : String = "LOCAL_PLAYER"
@export var start_direction : Vector2 = Vector2.ZERO
@export var faction_regiments : Array[Faction_Regiment] = []
@onready var regiments_preload = preload("res://faction_regiment_scene.tscn")
var session : Game_Session

func _ready():
	session = find_parent("Game_Session")
	if start_direction == Vector2.DOWN:
		create_test_regiments(Vector2(800,200))
	elif start_direction == Vector2.UP:
		create_test_regiments(Vector2(800,800))

func _process(delta):
	pass

func setup(faction_name : String, start_direction : Vector2 ):
	self.faction_name = faction_name
	self.start_direction = start_direction
	
func create_test_regiments(start_position : Vector2):
	var regiment = regiments_preload.instantiate()
	add_child(regiment)
	regiment.setup(start_direction, start_position)
	faction_regiments.append(regiment)

func guilog(test : String):
	session.gui.log(test)
