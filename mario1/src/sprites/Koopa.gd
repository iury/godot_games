extends "res://src/sprites/Enemy.gd"

func _physics_process(_delta):
	if movable and not frozen:
		$AnimatedSprite.flip_h = true if velocity.x < 0 else false
		match $AnimationTree["parameters/playback"].get_current_node():
			'Walk':
				if is_on_wall():
					velocity.x *= -1
			'Attacking':
				var col = move_and_collide(Vector2(velocity.x,0), true, true, true)
				if col and col.collider.get_collision_layer_bit(0):
					velocity.x *= -1


func kick(normal):
	match $AnimationTree["parameters/playback"].get_current_node():
		'Shell', 'Wake':
			attack(normal)


func attack(normal):
	SoundLibrary.play(SoundLibrary.Sounds.KICK)
	call_deferred('set_collision_layer_bit', 2, true)
	call_deferred('set_collision_layer_bit', 4, true)
	velocity = Vector2(4 if normal.x < 0 else -4, 3)
	if not is_in_group("enemies"):
		add_to_group("enemies")
	$AnimationTree["parameters/playback"].travel("Attacking")


func shell(_normal):
	SoundLibrary.play(SoundLibrary.Sounds.STOMP)
	set_collision_layer_bit(2, false)
	set_collision_layer_bit(4, false)
	velocity = Vector2.ZERO
	if is_in_group("enemies"):
		remove_from_group("enemies")
	$AnimationTree["parameters/playback"].travel("Shell")


func wake():
	set_collision_layer_bit(2, true)
	velocity = Vector2(-1, 3)
	if not is_in_group("enemies"):
		add_to_group("enemies")


func stomp(normal):
	match $AnimationTree["parameters/playback"].get_current_node():
		'Walk':
			shell(normal)
		'Shell', 'Wake':
			attack(normal)
		'Attacking':
			shell(normal)
