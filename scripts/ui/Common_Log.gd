class_name CommonLog
extends Control

@onready var rightRichLabelTextbox = $inner_panel/RichTextLabel



func log(text):
	rightRichLabelTextbox.append_text("\n" + str(text))
