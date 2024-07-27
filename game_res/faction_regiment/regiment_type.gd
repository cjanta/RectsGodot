extends Resource
class_name Regiment_Type

@export var regiment_name : String = "default name"
@export var regiment_texture : Texture2D = null
@export var regiment_unit_size : Vector3 = Vector3.ZERO
@export var regiment_color : Color = Color.WHITE
@export var regiment_unit_coords : Vector2 = Vector2.ZERO

var setup_position : Vector2 = Vector2.ZERO
var setup_facing_dir : Vector2 = Vector2.DOWN

const action_points_max : int = 128
var action_points : int = 128:
	set(value):
		action_points = value
		if action_points < 0:
			action_points = 0

func reset_action_points():
	action_points = action_points_max
