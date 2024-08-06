class_name SelectionDisplay
extends Control

signal update_selection_display(faction_regiment : FactionRegiment)

func _ready():
	visible = false

func update(faction_regiment : FactionRegiment):
	if faction_regiment != null:
		update_selection_display.emit(faction_regiment)
		visible = true
	else:
		visible = false

func clear():
	visible = false
