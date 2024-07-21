extends Panel

var styleBox: StyleBoxFlat
var default_border_color : Color = Color.WHITE_SMOKE

func _ready():
	styleBox = get_theme_stylebox("panel").duplicate()


func _on_faction_display_update_display(faction):
	change_border_Color(faction)

func change_border_Color(faction):
	styleBox.set("border_color", faction.faction_type.faction_color)
	add_theme_stylebox_override("panel", styleBox)

func change_color(faction):
	styleBox.set("bg_color", faction.faction_type.faction_color)
	add_theme_stylebox_override("panel", styleBox)
