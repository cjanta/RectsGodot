extends Sprite2D

var rastersize : float = 32.0

func _ready():
	var sprites_added = []
	sprites_added.append(get_sprite(0,0))
	sprites_added.append(get_sprite(0,1))
	sprites_added.append(get_sprite(1,0))

func get_sprite(row,col):
	var tex = texture
	var sprite = Sprite2D.new()
	sprite.texture = tex
	sprite.region_enabled = true
	sprite.region_rect = Rect2(row * rastersize,col * rastersize,rastersize,rastersize)
	randomize()
	sprite.global_position = Vector2(randi() % 1000,randi() % 1000)
	add_child(sprite)
