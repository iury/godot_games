extends Node2D

export(Vector2) var impulse = Vector2.ZERO setget set_impulse


func _draw():
	if impulse != Vector2.ZERO:
		var pos = Vector2.ZERO
		var gravity = Vector2(0, 98)
		var imp = impulse + gravity
		# warning-ignore:unused_variable
		for i in range(8):
			pos += imp * 0.1
			imp += gravity
			draw_circle(pos, 8, Color.white)


func set_impulse(value):
	impulse = value
	update()
