class_name  Faction_Unit_Ident
extends Node

@export var unit_name = ""
@export var icon_vector : Vector2 = Vector2.ZERO
@onready var sprite = $icon_sprite
@onready var rastersize : float = 32.0
var session : Game_Session

var isReady = false
func _ready():
	session = find_parent("Game_Session")
	
	
func setup(unitName, iconVector : Vector2):
	unit_name = unitName
	icon_vector = iconVector
	sprite.region_rect = Rect2(icon_vector.x * rastersize, icon_vector.y * rastersize, rastersize, rastersize)
	
func _process(delta):
	if not isReady:
		isReady = true
		

func guilog(test : String):
	session.gui.log(test)
