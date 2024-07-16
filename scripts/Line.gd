extends Node2D

@onready var regimentShape = $"../CollisionShape2D"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	queue_redraw()
	
func _draw():
	var dir = regimentShape.shape.extents
	var color = Color.ANTIQUE_WHITE
	color.a = 0.5
	draw_line(position,position + dir.rotated(rotation)  *2, color, 8.0, true)
	draw_line(position,position - dir.rotated(rotation) *2 , color, 8.0, true)
	dir = Vector2(-regimentShape.shape.extents.x,regimentShape.shape.extents.y)
	draw_line(position,position + dir.rotated(rotation)  *2, color, 8.0, true)
	draw_line(position,position - dir.rotated(rotation) *2 , color, 8.0, true)
	pass
	
