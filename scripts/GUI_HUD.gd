class_name GUI_Log
extends CanvasLayer


@onready var rightRichLabelTextbox = $ColorRect/RichTextLabel


func log(text):
	rightRichLabelTextbox.append_text("\n" + str(text))
