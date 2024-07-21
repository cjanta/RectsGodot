extends Sprite2D

class_name Unit

@export var unitName = "Mustermen"
@export var isAlive = true

@onready var deadImgRichText = "[img]" + "res://grfx/icon_Skull32.png" + "[/img]"

func get_unitName():
	return unitName;

func get_died_log():
	return deadImgRichText + get_rich_logPrefix()

func get_rich_logPrefix():
	return "[color=blue]" + unitName + "[/color]" 


func set_died():
	isAlive = false
	visible = false
