extends Panel

var styleBox: StyleBoxFlat
var default_border_color : Color = Color.WHITE_SMOKE

func _ready():
	styleBox = get_theme_stylebox("panel").duplicate()

func change_border_Color(color : Color):
	styleBox.set("border_color", color)
	add_theme_stylebox_override("panel", styleBox)

#func change_color(color : Color):
	#styleBox.set("bg_color", color)
	#add_theme_stylebox_override("panel", styleBox)
