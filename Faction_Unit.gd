class_name Faction_Unit
extends Node2D

@export var unit_ident : Faction_Unit_Ident = null
@onready var faction_unit_ident_preload = preload("res://faction_unit_ident.tscn")
var session : Game_Session

func _ready():
	session = find_parent("Game_Session")
	unit_ident = faction_unit_ident_preload.instantiate()
	add_child(unit_ident)
	randomize()
	var int3 = randi_range(0,3)
	unit_ident.setup("Soldat", Vector2(int3,7 ) )
	
	
func guilog(test : String):
	session.gui.log(test)
	
