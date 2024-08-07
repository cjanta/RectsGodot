class_name GameRoundHelper
extends Node2D

@export var session : GameSession
@export var round_display : GameRoundDisplay
@export var factions : Factions
@export var common_log : CommonLog

#game round
enum STATES {Start = 0 , Attack = 1, Actions = 2, Ranged = 3 ,Combat = 4, End = 5}
var current_state : STATES = -1
var game_round_counter = 1
var faction_at_turn_index = 0
var faction_has_turn : Faction

#logging
@onready var logging_color = Color.BLUE_VIOLET
var logging_color_html
var is_runtime_ini = true

func _ready():
	logging_color_html = logging_color.to_html()
	round_display.update_display(self)

func iterate_session_round():
	if current_state == STATES.End:
		game_round_counter += 1
	if current_state < STATES.size() -1:
		current_state += 1
	else:
		current_state = 0
	reset_action_points()
	reset_phase_finished()
	select_next_faction()
	common_log.log(get_rich_prefix_line())
	round_display.update_display(self)

func resolved_phase():
	#TODO schaltet noch nicht richtig
	if has_all_factions_endet_phase():
		iterate_session_round()
	else:
		select_next_faction()
	common_log.log(get_rich_suffix_line())
	round_display.update_display(self)
	
func reset_action_points():
	for faction in factions.all_factions:
		for regiment in faction.faction_regiments:
			regiment.type.reset_action_points()

func select_next_faction():
	var faction = factions.all_factions[faction_at_turn_index]
	faction.clear_after_phase(current_state)
	toogle_faction_at_turn_index()
	faction_has_turn = factions.all_factions[faction_at_turn_index]
	faction_has_turn.handle_phase(current_state)
	session.selected_regiment = null
	session.selection_display.clear()

func has_all_factions_endet_phase():
	for faction in factions.all_factions:
		if not faction.has_phase_finished:
			return false
	return true

func reset_phase_finished():
	for faction in factions.all_factions:
		faction.has_phase_finished = false;

func toogle_faction_at_turn_index():
	if faction_at_turn_index == 0:
		faction_at_turn_index = 1
	else:
		faction_at_turn_index = 0

func get_game_round_log():
	return "Runde [color=" + logging_color_html + "]" + str(game_round_counter) + "[/color]" 

func get_selected_faction_log(selected_faction : Faction):
	if selected_faction != null:
		return "[color=" + selected_faction.faction_color_html + "]" + selected_faction.faction_name + "[/color]" 
	return "error"	

func get_state_log():
	var log = str(current_state)
	if current_state == STATES.Start:
		return "Start der Runde"
	elif current_state == STATES.Attack:
		return "Angriff"
	elif current_state == STATES.Actions:
		return "Manöver"
	elif current_state == STATES.Ranged:
		return "Fernkampf"
	elif current_state == STATES.Combat:
		return "Nahkampf"
	elif current_state == STATES.End:
		return "Ende der Runde"
	return log

func get_state_faction_info_log():
	var log = str(current_state)
	if current_state == STATES.Start:
		return "Aktionen zum Rundenstart"
	elif current_state == STATES.Attack:
		return "deklariert einen Angriff oder überspringt"
	elif current_state == STATES.Actions:
		return "führt ein Manöver aus oder überspringt"
	elif current_state == STATES.Ranged:
		return "führt einen Fernkampf aus oder überspringt"
	elif current_state == STATES.Combat:
		return "Nahkampfphase"
	elif current_state == STATES.End:
		return "Aktionen zum Ende der Runde"
	return log

func get_game_round_display_log():
	if faction_has_turn != null:
		var first_line = get_rich_prefix_line()
		var second_line = get_rich_suffix_line()
		return first_line + "\n\t" + second_line
	else:
		return "\t" + "\t" +"\t" +"\t" + "click to start"

func get_rich_suffix_line():
	return get_selected_faction_log(faction_has_turn) + "\t" + get_state_faction_info_log()

func get_rich_prefix_line():
	return get_game_round_log() + "\t" + get_state_log()
	
