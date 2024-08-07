class_name GameSession
extends Node2D
#setup
@export var gui : CommonLog
@export var selection_display : SelectionDisplay
@export var target_selection_display : SelectionDisplay
@export var game_round_display : GameRoundDisplay
@export var factions : Factions
@export var data : Data
@export var game_round : GameRoundHelper

var is_runtime_ini = true;
#logging
@onready var logging_color = Color.MOCCASIN
var logging_color_html

#selection
var selected_regiment : FactionRegiment

func _ready():
	logging_color_html = logging_color.to_html()

func _process(delta):
	check_runtime_ini()

func check_runtime_ini():
	if is_runtime_ini:
		is_runtime_ini = false
		runtime_ini()

func set_selected_regiment(faction_Regiment : FactionRegiment):
	if not is_selected_regiment(faction_Regiment):
		selected_regiment = faction_Regiment
		selection_display.update(faction_Regiment)

func update_selection_display(faction_Regiment : FactionRegiment):
	selection_display.update(faction_Regiment)

func remove_selected_regiment(faction_Regiment : FactionRegiment):
	if is_selected_regiment(faction_Regiment):
		selected_regiment = null
		selection_display.clear()

func is_selected_regiment(faction_Regiment : FactionRegiment):
	return selected_regiment == faction_Regiment

func runtime_ini():
	var faction = factions.all_factions[0]
	factions.display_faction_left(faction)
	faction = factions.all_factions[1]
	factions.display_faction_right(faction)
	
func _input(event):
	if Input.is_action_just_pressed("spacebar"):
		game_round.resolved_phase()

func get_other_faction(regiment : FactionRegiment):
	for fac in factions.all_factions:
		if fac != regiment.faction:
			return fac

func _on_session_round_display_clicked_session_round_display():
	game_round.iterate_session_round()
