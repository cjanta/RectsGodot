class_name CommonLog
extends Control

@export var textbox : RichTextLabel

var original_size : Vector2
var max_size : Vector2

func log(text):
	textbox.append_text("\n" + str(text))

func _ready():
	original_size = size
	max_size = Vector2(original_size.x,get_viewport_size().y - original_size.y - position.y)

func _on_gui_input(event):
	if event is InputEventMouseButton and event.double_click:
		toggle_size()

func toggle_size():
	if size == original_size:
		size = max_size
	else:
		size = original_size

func get_viewport_size() -> Vector2:
	return get_viewport_rect().size

func _on_rich_text_label_meta_clicked(meta):
	handle(meta)

func handle(argument):
	match argument:
		"print": OS.shell_open("https://www.google.de/")
		"quit": get_tree().quit()
