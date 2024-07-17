extends Sprite2D


var initial_size
var regiment
var hitbox_regiment_bounds
var new_scale : Vector2

func _ready():
	initial_size = texture.get_size()
	regiment = get_parent() as Faction_Regiment
	var bounds = regiment.get_current_bounds_extends()
	var x_ratio = (bounds.x * 2.0)  / initial_size.x 
	var y_ratio = (bounds.y * 2.0) / initial_size.y 	
	new_scale = Vector2(x_ratio,y_ratio)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if scale != new_scale:
		scale = new_scale
