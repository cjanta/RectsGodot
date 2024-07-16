class_name Game_Session
extends Node2D

var is_runtime_ini = true;
@onready var factions : Factions = $Factions as Factions
@export var gui : GUI_Log

var session_counter = 1

func _ready():
	pass

func _process(delta):
	check_runtime_ini()

func check_runtime_ini():
	if is_runtime_ini:
		is_runtime_ini = false
		runtime_ini()

func runtime_ini():
	gui.log(factions.get_all_factions_log())
