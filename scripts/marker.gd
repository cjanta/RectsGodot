extends Sprite2D

@onready var label = $Label
var round = 0
var round_info = "Kampfrunde: "

func addRound():
	round += 1
	label.text =  round_info + str(round)

func getRoundInfo():
	return round_info + str(round)
