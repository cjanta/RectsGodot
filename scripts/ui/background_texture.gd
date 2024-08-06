extends TextureRect

@onready var selection_display_panel = $".."

func _on_selection_display_update_selection_display(faction_regiment):
	if faction_regiment != null:
		var regiment = faction_regiment as FactionRegiment
		texture = regiment.faction.faction_texture
