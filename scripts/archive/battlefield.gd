extends Node2D

@onready var preloadRegiment = preload("res://scns/regiment.tscn")
@onready var GUI_HUD = $"../GUI_HUD"
var regiments = []

var counter_rounds = 0;
# Called when the node enters the scene tree for the first time.
func _ready():
	var regiment = preloadRegiment.instantiate()
	regiment.global_position = Vector2(800,1000)
	regiment.regiment_ID = "Waffenbrüder"
	regiment.gui = GUI_HUD
	regiments.append(regiment)
	add_child(regiment)	

	regiment = preloadRegiment.instantiate()
	regiment.global_position = Vector2(800,100)
	regiment.regiment_ID = "Trutzkameraden"
	regiment.rotation_degrees += 180
	regiment.gui = GUI_HUD
	regiments.append(regiment)
	add_child(regiment)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if Input.is_action_just_released("Spacebar"):
		counter_rounds += 1
		GUI_HUD.log("Runde: " + str(counter_rounds))
		for reg in regiments:
			if reg == null or reg.is_queued_for_deletion():
				if reg in regiments:
					regiments.erase(reg)
			else:
				if reg != null and reg in regiments:
					reg.update_hasBattle()
