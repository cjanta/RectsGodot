class_name RegimentType
extends Resource
enum REGIMENT_CLASS{ empty = 0, Regiment = 1, Single = 2, Skirmish = 3 , Loose = 4}

#visuals
@export var sprite_scene : PackedScene
@export var has_spritesheet = false
@export var unit_texture : Texture2D
@export var unit_region_data : Vector3 = Vector3.ZERO
@export var regiment_color : Color = Color.WHITE
var regiment_texture : Texture2D = null #getsFactionTexture

#DEV: battle setup
var setup_position : Vector2 = Vector2.ZERO
var setup_facing_dir : Vector2 = Vector2.DOWN

#stats
@export var regiment_name : String = "Hungrige Wölfe"
@export var regiment_template_name : String = "Schwertkämpfer"
@export var regiment_class : REGIMENT_CLASS = REGIMENT_CLASS.Regiment
@export var regiment_unit_size : Vector3 = Vector3.ZERO

@export var stat_move : int = 0
@export var stat_battle : int = 0
@export var stat_rangedl : int = 0
@export var stat_strength : int = 0
@export var stat_toughness : int = 0
@export var stat_life : int = 0
@export var stat_initiative : int = 0
@export var stat_attacks : int = 0
@export var stat_moral : int = 0
@export var special_rules : Array = []
@export var regiment_gear : Array = []

var action_points_max : float = 0
var charge_range : float = 0
var action_points : float = 0:
	set(value):
		action_points = value
		if action_points < 0:
			action_points = 0

func reset_action_points():
	action_points = action_points_max

func setup(_setup_position : Vector2, _setup_facing_dir : Vector2):
	setup_position = _setup_position
	setup_facing_dir = _setup_facing_dir
	action_points_max = float(stat_move * 64)
	charge_range = action_points_max * 2.0
	action_points = float(stat_move * 64)
