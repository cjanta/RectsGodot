extends RichTextLabel






func _on_session_round_display_update_session_round_display(session):
	text = session.get_session_round_display_log()
