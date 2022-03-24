extends KinematicBody2D


var velocity = Vector2(1.5,4)
var movable = false

func _physics_process(_delta):
	if not movable: return
	
	# warning-ignore:return_value_discarded
	move_and_slide(velocity*32, Vector2.UP)
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		hit(collision.collider, collision.normal)
		if collision.collider.has_method("hit"):
			collision.collider.hit(self, collision.normal)
	if is_on_wall():
		velocity.x *= -1


func hit(from, _normal):
	if from == Mario:
		SoundLibrary.play(SoundLibrary.Sounds.UP)
		queue_free()


func rise():
	$Tween.interpolate_property(self, "global_position", global_position, global_position+Vector2(0, -12), 0.8)
	$Tween.start()
	yield(get_tree().create_timer(0.8), "timeout")
	movable = true
