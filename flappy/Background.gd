extends Node

export(Vector2) var velocity = Vector2(-80, 0)

func _process(delta):
	if velocity != Vector2.ZERO:
		velocity.x = wrapf(velocity.x + -80 * delta, -413, 0)
		$ParallaxBackground.scroll_offset = velocity
		$ParallaxGround.scroll_offset = velocity
