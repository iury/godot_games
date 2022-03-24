extends StaticBody2D


func hit(from, _normal):
	if from == Mario:
		Mario.fire_power()
		queue_free()


func rise():
	$Tween.interpolate_property(self, "global_position", global_position, global_position+Vector2(0, -12), 0.8)
	$Tween.start()
	yield(get_tree().create_timer(0.8), "timeout")
