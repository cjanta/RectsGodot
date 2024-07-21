class_name Game_Session
extends Node2D

@export var gui : CommonLog
@export var selection_display : SelectionDisplay

@onready var factions : Factions = $Factions as Factions
var is_runtime_ini = true;
var session_counter = 1

var selected_regiment : Faction_Regiment

func _ready():
	pass

func _process(delta):
	check_runtime_ini()

func check_runtime_ini():
	if is_runtime_ini:
		is_runtime_ini = false
		runtime_ini()

func set_selected_regiment(faction_Regiment : Faction_Regiment):
	if not is_selected_regiment(faction_Regiment):
		selected_regiment = faction_Regiment
		selection_display.update(faction_Regiment)

func is_selected_regiment(faction_Regiment : Faction_Regiment):
	return selected_regiment == faction_Regiment

func runtime_ini():
	gui.log(factions.get_all_factions_log())
	var faction = factions.all_factions[0]
	factions.display_faction_left(faction)
	faction = factions.all_factions[1]
	factions.display_faction_right(faction)
