extends RichTextLabel

@onready var selection_display_panel = $"../.."

func _on_selection_display_update_selection_display(faction_regiment):
	if faction_regiment != null:
		text = faction_regiment.get_rich_display_prefix()
		selection_display_panel.change_border_Color(faction_regiment.faction.faction_color)
