class_name Faction_Unit
extends Node2D

var session : Game_Session

@export var unit_name = ""
@export var icon_vector : Vector2 = Vector2.ZERO
@onready var sprite = $icon_sprite
@onready var rastersize : float = 32.0


func _ready():
	session = find_parent("Game_Session")
	setup()

func setup():
	unit_name = "Soldat"
	randomize()
	var int3 = randi_range(0,3)
	icon_vector = Vector2(int3,7 )
	sprite.region_rect = Rect2(icon_vector.x * rastersize, icon_vector.y * rastersize, rastersize, rastersize)

func guilog(text : String):
	session.gui.log(text)
	
