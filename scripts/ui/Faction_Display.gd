class_name Faction_Display
extends Control

signal update_display(faction : Faction)

func display_faction(faction : Faction):
	update_display.emit(faction)
