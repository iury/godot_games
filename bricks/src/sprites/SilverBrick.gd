extends "res://src/sprites/BaseBrick.gd"

func _init():
	color_offset = 0
	hp = 2+GameData.level/8

func hit(from_bullet):
	$AnimatedSprite.frame = 0
	$AnimatedSprite.play()
	GameData.score += 50 * GameData.level
	.hit(from_bullet)
