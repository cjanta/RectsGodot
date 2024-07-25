extends Label

func _on_faction_display_update_display(faction : Faction):
	text = faction.faction_name
	set("theme_override_colors/font_color",faction.faction_type.faction_color)
