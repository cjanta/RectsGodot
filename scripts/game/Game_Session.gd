class_name Game_Session
extends Node2D

@export var gui : CommonLog
@export var selection_display : SelectionDisplay
@export var session_round_display : Session_Round_Display
@export var factions : Factions
@export var data : Data

var is_runtime_ini = true;


@onready var logging_color = Color.MOCCASIN

var logging_color_html
var session_round_counter = 0
var faction_turn_index = 0

var faction_has_turn : Faction
var selected_regiment : Faction_Regiment

func _ready():
	logging_color_html = logging_color.to_html()

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

func update_selection_display(faction_Regiment : Faction_Regiment):
	selection_display.update(faction_Regiment)

func remove_selected_regiment(faction_Regiment : Faction_Regiment):
	if is_selected_regiment(faction_Regiment):
		selected_regiment = null
		selection_display.clear()

func is_selected_regiment(faction_Regiment : Faction_Regiment):
	return selected_regiment == faction_Regiment

func runtime_ini():
	var faction = factions.all_factions[0]
	factions.display_faction_left(faction)
	faction = factions.all_factions[1]
	factions.display_faction_right(faction)
	iterate_session_round()
	
func _input(event):
	if Input.is_action_just_pressed("spacebar"):
		iterate_session_round()

func get_rich_round_log():
	return "Runde [color=" + logging_color_html + "]" + str(session_round_counter) + "[/color]" 

func get_rich_faction_turn_log(selected_faction : Faction):
	if selected_faction != null:
		return "[color=" + selected_faction.faction_color_html + "]" + selected_faction.faction_name + "[/color]" 
	return "error"	

func get_session_round_display_log():
	return get_rich_round_log() + "\n\t" + get_rich_faction_turn_log(faction_has_turn)


func iterate_session_round():
	session_round_counter += 1
	gui.log(get_rich_round_log())
	for faction in factions.all_factions:
		for regiment in faction.faction_regiments:
			regiment.type.reset_action_points()
	
	select_faction()
	gui.log(get_rich_faction_turn_log(faction_has_turn))
	session_round_display.update(self)

func select_faction():
	update_selectable_regiments(factions.all_factions[faction_turn_index], false)
	if faction_turn_index == 0:
		faction_turn_index = 1
	else:
		faction_turn_index = 0
	faction_has_turn = factions.all_factions[faction_turn_index]
	update_selectable_regiments(factions.all_factions[faction_turn_index], true)
	selected_regiment = null
	selection_display.clear()
	
func update_selectable_regiments(faction : Faction, isSelectable : bool):
	for regiment in faction.faction_regiments:
		regiment.is_Selectable = isSelectable	

func _on_session_round_display_clicked_session_round_display():
	iterate_session_round()
