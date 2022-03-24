extends StaticBody2D

const broken_brick = preload("res://src/sprites/BrokenBrick.tscn")


func hit(from, _normal):
	if from == Mario and from.is_on_ceiling():
		var pos = global_position + Vector2(0, -16)
		position.y -= 4
		if Mario.is_big:
			set_collision_layer_bit(4, true)
			SoundLibrary.play(SoundLibrary.Sounds.BRICK_SMASH)
			var b = broken_brick.instance()
			b.global_position = pos
			get_parent().add_child(b)
			modulate = Color.transparent
			yield(get_tree().create_timer(0.1), "timeout")
			queue_free()
		else:
			SoundLibrary.play(SoundLibrary.Sounds.BUMP)
			yield(get_tree().create_timer(0.1), "timeout")
			set_collision_layer_bit(4, false)
			position.y += 2
			yield(get_tree().create_timer(0.1), "timeout")
			position.y += 2
