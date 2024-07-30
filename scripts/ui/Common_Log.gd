class_name CommonLog
extends Control

@onready var rightRichLabelTextbox = $inner_panel/RichTextLabel
var original_size : Vector2
var max_size : Vector2

func log(text):
	rightRichLabelTextbox.append_text("\n" + str(text))

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
