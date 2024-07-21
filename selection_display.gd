class_name SelectionDisplay
extends Control


signal update_selection_display(faction_regiment : Faction_Regiment)



func update(faction_regiment : Faction_Regiment):
	update_selection_display.emit(faction_regiment)
