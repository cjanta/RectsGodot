class_name GameRoundDisplay
extends Control

signal clicked_session_round_display()
signal update_session_round_display(game_round : GameRoundHelper)
var game_round : GameRoundHelper

func update_display(game_round_helper : GameRoundHelper):
	game_round = game_round_helper
	update_session_round_display.emit(game_round)

func _on_session_round_display_label_gui_input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			clicked_session_round_display.emit()
