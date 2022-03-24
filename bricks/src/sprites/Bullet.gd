extends KinematicBody2D

func _physics_process(delta):
	var collision = move_and_collide(Vector2.UP * 600 * delta)
	if collision:
		if collision.collider.has_method("hit"):
			collision.collider.hit(true)
		queue_free()
