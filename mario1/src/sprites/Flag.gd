extends StaticBody2D

func hit(from, _normal):
	if from == Mario:
		SoundLibrary.stop(SoundLibrary.Sounds.MAIN_THEME)
		SoundLibrary.play(SoundLibrary.Sounds.FLAGPOLE)
		Mario.movable = false
		var tree = Mario.get_node("AnimationTree")
		tree["parameters/Slide/blend_position"] = 1 if Mario.is_big else -1
		tree["parameters/playback"].travel("Slide")
		Mario.global_position.x = global_position.x + 4
		$Timer.start()
		$Tween.interpolate_property($Sprite, "global_position", global_position, global_position + Vector2(0, 128), 1)
		$Tween.start()
		yield(get_tree().create_timer(1.3), "timeout")

		SoundLibrary.play(SoundLibrary.Sounds.STAGE_CLEAR)
		$Timer.stop()
		yield(get_tree().create_timer(1.2), "timeout")

		Mario.position += Vector2(10, 0)
		yield(get_tree().create_timer(0.8), "timeout")

		Mario.force_move_right = true
		Mario.velocity.y = 0
		Mario.movable = true
		yield(get_tree().create_timer(2), "timeout")

		var flag = get_tree().get_nodes_in_group("castle_flag")[0]
		$Tween.interpolate_property(flag, "global_position", flag.global_position, flag.global_position + Vector2(0, -32), 0.8)
		$Tween.start()
		yield(get_tree().create_timer(2.5), "timeout")

		Mario.reset_state()
		Mario.is_big = false
		Mario.can_fire = false
		Mario.global_position = Vector2.ZERO
		GameData.spawn_point = "breakpoints"
		# warning-ignore:return_value_discarded
		get_tree().reload_current_scene()


func _on_Timer_timeout():
	if Mario.global_position.y < 176:
		Mario.global_position.y += 2
