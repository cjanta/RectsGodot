class_name SessionRoundDisplay
extends Control

signal clicked_session_round_display()
signal update_session_round_display(session : GameSession)
var session : GameSession

func update(game_session : GameSession):
	session = game_session
	update_session_round_display.emit(session)

func _on_session_round_display_label_gui_input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			clicked_session_round_display.emit()
