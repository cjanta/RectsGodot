class_name Faction
extends Node2D

@export var faction_name : String = "muster_faction_name"
@export var owner_ident : String = "LOCAL_PLAYER"
@export var start_direction : Vector2 = Vector2.ZERO
@export var faction_regiments : Array[Faction_Regiment] = []
@onready var regiments_preload = preload("res://faction_regiment_scene.tscn")
var session : Game_Session
var sum_regiments = 0

func _ready():
	session = find_parent("Game_Session")
	var x_off = 200
	var num_per_faction = 3
	if start_direction == Vector2.DOWN:
		for n in num_per_faction:
			sum_regiments += 1
			create_test_regiments(Vector2(x_off+ n*400,100))
	elif start_direction == Vector2.UP:
		for n in num_per_faction:
			sum_regiments += 1
			create_test_regiments(Vector2(x_off+ n*400,700))

func _process(delta):
	pass

func setup(faction_name : String, start_direction : Vector2 ):
	self.faction_name = faction_name
	self.start_direction = start_direction
	
func create_test_regiments(start_position : Vector2):
	var regiment = regiments_preload.instantiate()
	add_child(regiment)
	randomize()
	randi()
	var number_units = randi_range(10,101)
	regiment.setup("Regiment: " + str(sum_regiments),start_direction, start_position, Vector3(number_units, 10.0, 1.0 ))
	faction_regiments.append(regiment)

func guilog(test : String):
	session.gui.log(test)
