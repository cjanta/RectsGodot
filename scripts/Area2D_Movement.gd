extends Area2D
@onready var regiment = $".."
@onready var node_to_update = [$"../Area2D_Rotation",$"../BattleLabel"]
@onready var areaEnemeyRange = $"../Area2D_EnemyRange"
@onready var shape = $CollisionShape2D
@onready var preloadUnitIcon = preload("res://scns/unit_icon.tscn")
@onready var enemy_range_shape = $"../Area2D_EnemyRange/CollisionShape2D"

var shape_extends = Vector2.ZERO
var relative_position = Vector2.ZERO
var rect =  Rect2()
var regiment_unit_size = Vector3(25,10,2)
var unit_size = 32.0
var unitIcons = []

func _ready():
	regiment_unit_size.z = ceil(regiment_unit_size.x / regiment_unit_size.y)
	shape.shape.extents = Vector2(regiment_unit_size.y * unit_size /2  ,regiment_unit_size.z * unit_size /2  )
	enemy_range_shape.shape.radius = regiment_unit_size.y * unit_size / 2 
	update_relatives()
	setupUnitIcons()
	setup_child_positions_if()

func setup_child_positions_if():
	var y_offset =  -(shape_extends.y - unit_size / 2.0)
	for node in node_to_update:
		node.position += Vector2(0,y_offset)
	
func setupUnitIcons():
	var offset = Vector2(unit_size/2,unit_size/2)
	for n in regiment_unit_size.x:		
		var sprite = preloadUnitIcon.instantiate()
		sprite.unitName = "Soldat " + str(n)
		var collum =  floor(n / regiment_unit_size.y)
		sprite.position = relative_position + Vector2(n * unit_size - collum * regiment_unit_size.y * unit_size , collum * unit_size ) + offset
		regiment.units.append(sprite)
		add_child(sprite)
		unitIcons.append(sprite)

func _process(delta):
	update_relatives()
	queue_redraw()

func update_relatives():
	shape_extends = Vector2(shape.shape.extents.x *2, shape.shape.extents.y *2)
	relative_position = Vector2(position.x - shape_extends.x / 2.0, position.y - shape_extends.y / 2.0)
	rect =  Rect2(relative_position,shape_extends)

func _draw():
	draw_rect(rect,Color.WHITE)
