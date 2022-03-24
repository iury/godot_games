extends "res://src/sprites/BaseBrick.gd"

func _ready():
	$Sprite.frame = color_offset-1
	if color_offset == 9:
		hp = (1 << 31) - 1

func hit(from_bullet):
	if color_offset != 9:
		GameData.score += 40 + color_offset*10
	.hit(from_bullet)
