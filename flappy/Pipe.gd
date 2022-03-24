extends StaticBody2D

var moving = true
var scored = false

func flip():
	$Sprite.flip_v = true


func _physics_process(delta):
	if moving:
		position.x -= 160 * delta
		if not scored and position.x < 30:
			scored = true
			GameData.score += 0.5


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func hit():
	moving = false
