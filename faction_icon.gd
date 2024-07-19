extends Sprite2D

var initial_size
var regiment
var hitbox_regiment_bounds
var new_scale : Vector2

func _ready():
	initial_size = texture.get_size()
	regiment = get_parent() as Faction_Regiment

func update_scale(current_Bounds_extend : Vector2):
	var x_ratio = (current_Bounds_extend.x * 2.0)  / initial_size.x 
	var y_ratio = (current_Bounds_extend.y * 2.0) / initial_size.y 	
	new_scale = Vector2(x_ratio,y_ratio)

func _process(delta):
	if scale != new_scale:
		scale = new_scale

func _on_faction_regiment_scene_update_visuals(current_bounds_extends):
	update_scale(current_bounds_extends)
