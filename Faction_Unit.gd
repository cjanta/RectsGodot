class_name Faction_Unit
extends Node2D

@onready var sprite = %regiment_icon
@onready var spritesheet = preload("res://grfx/sheets/#1 - Transparent Icons.png")
@onready var rastersize : float = 32.0
@export var sprite_row_col : Vector2 = Vector2(1,7)
@export var unit_name : String = ""

func _ready():
	setupSprites(sprite_row_col)

func setup(row_col : Vector2):
	self.sprite_row_col = row_col
	
func setupSprites(sprite_row_col : Vector2):
	sprite.region_rect = Rect2(sprite_row_col.x * rastersize, sprite_row_col.y * rastersize, rastersize, rastersize)

	
