class_name Session_Round_Display
extends Control


signal update_session_round_display(session : Game_Session)



func update(session : Game_Session):
	update_session_round_display.emit(session)
