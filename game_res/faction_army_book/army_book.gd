class_name ArmyBook
extends Resource

enum ARMY_BOOKS { EMPIRE = 0, UNDEAD = 1}
enum UNIT_CATS { empty = 0, COMAND = 1, HERO = 2, CORE_UNIT = 3, ELITE = 4, RARE = 5, CHAMPIONS = 6, MOUNT = 7 }

@export var army_book_class : ARMY_BOOKS = 0
@export var regiment_types : Array[RegimentType]



func get_regiment_type(index : int):
	return regiment_types[index].duplicate()

func get_random_regiment_type(book_index : ARMY_BOOKS):
	return get_regiment_type(randi_range(book_index,regiment_types.size()-1))
