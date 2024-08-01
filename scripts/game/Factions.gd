class_name Factions
extends Node2D

@export var all_factions : Array[Faction] = []
@onready var faction_preload
@onready var gui : GUI_Log = $"../GUI/main/Common_Log" as GUI_Log
@onready var gui_faction_display_north =$"../GUI/main/Faction_Display_North" as FactionDisplay
@onready var gui_faction_display_south = $"../GUI/main/Faction_Display_South" as FactionDisplay

@export var faction_types : Array[FactionType]

func _ready():
	faction_preload = load("res://scns/game/faction_scene.tscn")	
	create_faction(0)
	create_faction(1)

func create_faction(index :int):
	var faction = faction_preload.instantiate() as Faction
	var type = faction_types[index]
	faction.setup(type)
	all_factions.append(faction)
	add_child(faction)

func get_all_factions_log():
	var info = ""
	for faction in all_factions:
		info += faction.get_rich_logPrefix() + "\t"
	return info

func display_faction_left(faction : Faction):
	gui_faction_display_north.display_faction(faction)

func display_faction_right(faction : Faction):
	gui_faction_display_south.display_faction(faction)

func _process(delta):
	pass
