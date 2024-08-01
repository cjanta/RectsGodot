class_name FactionDisplay
extends Control

signal update_display(faction : Faction)

func display_faction(faction : Faction):
	update_display.emit(faction)
