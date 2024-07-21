class_name Factions
extends Node2D

@export var all_factions : Array[Faction] = []
@onready var faction_preload
@onready var gui : GUI_Log = $"../GUI/main/Common_Log" as GUI_Log
@onready var gui_faction_display_left =$"../GUI/main/Faction_Display_Left"  as Faction_Display
@onready var gui_faction_display_right =$"../GUI/main/Faction_Display_Right"  as Faction_Display

@export var faction_type = load("res://game_res/faction_type/taction_type_north.tres")
var faction_paths : Array[String] = ["res://game_res/faction_type/taction_type_north.tres","res://game_res/faction_type/taction_type_sued.tres" ]

func _ready():
	faction_preload = load("res://scns/game/faction_scene.tscn")	
	create_faction(0)
	create_faction(1)
	

func create_faction(index :int):
	var faction = faction_preload.instantiate() as Faction
	var type = load(faction_paths[index])
	faction.setup(type)
	all_factions.append(faction)
	add_child(faction)

func get_all_factions_log():
	var info = ""
	for faction in all_factions:
		info += faction.get_rich_logPrefix() + "\t"
	return info

func display_faction_left(faction : Faction):
	gui_faction_display_left.display_faction(faction)
	
func display_faction_right(faction : Faction):
	gui_faction_display_right.display_faction(faction)


func _process(delta):
	pass
