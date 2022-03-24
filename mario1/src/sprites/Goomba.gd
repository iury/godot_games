extends "res://src/sprites/Enemy.gd"

func _physics_process(_delta):
	if is_on_wall():
		velocity.x *= -1
