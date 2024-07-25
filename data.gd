class_name Data
extends Node

enum regiment_type_names { KNIGHT = 0, ranger = 1}

@export var regiment_types : Array[Regiment_Type]

func get_regiment_type(name : regiment_type_names):
	var index = name
	return regiment_types[index].duplicate()

func get_random_regiment_type():
	return get_regiment_type(randi_range(0,regiment_types.size()-1))
