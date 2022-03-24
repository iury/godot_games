extends KinematicBody2D

var velocity = Vector2(-1, 3)
var movable = false
var frozen = false


func _ready():
	visible = false
	# warning-ignore:return_value_discarded
	self.connect("visibility_changed", self, "_on_visibility_changed")


func _physics_process(_delta):
	if movable and not frozen:
		$AnimatedSprite.play()
		# warning-ignore:return_value_discarded
		move_and_slide(velocity*32, Vector2.UP)
		for i in get_slide_count():
			var collision = get_slide_collision(i)
			hit(collision.collider, collision.normal)
			if collision.collider.has_method("hit"):
				collision.collider.hit(self, collision.normal)
	else:
		$AnimatedSprite.stop()


func _process(_delta):
	var camera = Mario.get_node("Camera2D").get_camera_screen_center().x
	var screen = get_viewport_rect().size.x/2
	if position.x-8 < camera+screen:
		visible = true
	if position.y > 240 or position.x+8 < camera-screen:
		queue_free()


func hit(from, normal):
	if from.get_collision_layer_bit(4):
		fall_from_screen()
	elif from == Mario and Mario.was_on_air:
		stomp(normal)
	elif from == Mario and not Mario.was_on_air:
		kick(normal)


func stomp(_normal):
	SoundLibrary.play(SoundLibrary.Sounds.STOMP)
	movable = false
	collision_layer = 0
	collision_mask = 0
	$AnimatedSprite.animation = "stomp"
	yield(get_tree().create_timer(0.3), "timeout")
	queue_free()


func kick(_normal):
	pass


func fall_from_screen():
	SoundLibrary.play(SoundLibrary.Sounds.KICK)
	movable = false
	collision_layer = 0
	collision_mask = 0
	z_index = 999
	$AnimatedSprite.flip_v = true
	$AnimatedSprite.stop()
	$Tween.interpolate_property(self, "position", position, position+Vector2(8,-8), 0.2)
	$Tween.start()
	yield(get_tree().create_timer(0.2), "timeout")
	$Tween.interpolate_property(self, "position", position, position+Vector2(32,256), 1.5)
	$Tween.start()


func _on_visibility_changed():
	if visible: movable = true
