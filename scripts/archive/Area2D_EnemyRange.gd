extends Area2D

@onready var collShape = $CollisionShape2D

func _process(delta):
	queue_redraw()
	
func _draw():
	var shape = collShape.shape;
	draw_circle(position,shape.radius ,Color.WHEAT)
