extends RichTextLabel


func add_game_round_log(game_round : GameRoundHelper):
	text = game_round.get_game_round_display_log()


func _on_session_round_display_update_session_round_display(game_round : GameRoundHelper):
	add_game_round_log(game_round)
