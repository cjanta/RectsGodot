extends RichTextLabel






func _on_selection_display_update_selection_display(faction_regiment):
	text = faction_regiment.get_rich_logPrefix()
