extends KinematicBody2D

var velocity = Vector2.ZERO
var speed = 180

func _physics_process(delta):
	var collision = move_and_collide(velocity * speed * delta)
	if collision:
		if collision.normal.x != 0:
			$Hit.play()
			speed = clamp(speed*1.05, 180, 360)
			var p = collision.position.y - collision.collider.global_position.y
			var angle = PI/2 * -p/24 - PI
			velocity = Vector2(cos(angle) * -collision.normal.x, sin(angle))
		else:
			velocity = velocity.bounce(collision.normal)


func _input(event):
	if velocity == Vector2.ZERO and event.is_action_pressed("ui_accept"):
		var clone = duplicate()
		var direction = Vector2.RIGHT if global_position.x < 160 else Vector2.LEFT
		clone.velocity = direction.rotated(deg2rad(-45 if randi() % 2 == 0 else 45))
		clone.global_position = global_position
		get_tree().current_scene.add_child(clone)
		queue_free()
