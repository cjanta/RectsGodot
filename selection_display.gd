class_name SelectionDisplay
extends Control



signal update_selection_display(faction_regiment : Faction_Regiment)

func _ready():
	visible = false

func update(faction_regiment : Faction_Regiment):
	update_selection_display.emit(faction_regiment)
	visible = true

func clear():
	visible = false
