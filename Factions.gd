class_name Factions
extends Node2D

@export var all_factions : Array[Faction] = []
@onready var faction_preload = preload("res://faction.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	create_faction("Nord Fraktion", Vector2.DOWN)
	create_faction("Süd Fraktion", Vector2.UP)

func create_faction(faction_name : String, start_direction : Vector2):
	var faction = faction_preload.instantiate()
	faction.setup(faction_name,start_direction)
	all_factions.append(faction)
	add_child(faction)

func get_all_factions_log():
	var info = ""
	for faction in all_factions:
		info += faction.faction_name + "\t"
	return info

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass