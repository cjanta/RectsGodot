class_name Session_Round_Display
extends Control

signal clicked_session_round_display()
signal update_session_round_display(session : Game_Session)
var session : Game_Session


func update(game_session : Game_Session):
	session = game_session
	update_session_round_display.emit(session)

			
			


func _on_session_round_display_label_gui_input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			clicked_session_round_display.emit()
