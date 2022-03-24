extends KinematicBody2D

signal hit

var dead = false
var pos = 0


func calculate_curve(t):
	var p0 = Vector2(0, -120)
	var p1 = Vector2(1200, -180)
	var p2 = Vector2(1200, 600)
	var q0 = p0.linear_interpolate(p1, t)
	var q1 = p1.linear_interpolate(p2, t)
	return q0.linear_interpolate(q1, t)


func _physics_process(delta):
	if not dead:
		var curve = calculate_curve(pos)
		# warning-ignore:return_value_discarded
		move_and_slide(Vector2(0, curve.y), Vector2.UP)
		pos += delta

		if get_slide_count() > 0:
			dead = true
			$Blood.emitting = true
			get_tree().call_group("pipes", "hit")
			emit_signal("hit")
		else:
			rotation = clamp(curve.angle(), -PI/4, PI/2)
	else:
		# warning-ignore:return_value_discarded
		move_and_slide(Vector2.DOWN * 360)


func _input(event):
	if not dead and global_position.y > 0 and event.is_action_pressed("ui_accept"):
		SoundLibrary.play(SoundLibrary.Sounds.WING)
		pos = 0
