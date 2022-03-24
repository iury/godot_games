extends KinematicBody2D

var velocity = Vector2(0x3900, 0)
var gravity = 0x400

func _ready():
	SoundLibrary.play(SoundLibrary.Sounds.FIRE)
	velocity.x *= Mario.face_direction

func _physics_process(delta):
	rotate(delta*15)
	velocity.y += gravity
	
	# warning-ignore:return_value_discarded
	move_and_slide(velocity/0x1000/delta, Vector2.UP)
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.has_method("hit"):
			collision.collider.hit(self, collision.normal)
	if is_on_ceiling():
		velocity.y = 0
	elif is_on_floor():
		velocity.y = -0x2900
	elif is_on_wall():
		queue_free()


func _process(_delta):
	var screen = get_viewport_rect().size.x/2
	var camera = Mario.get_node("Camera2D").get_camera_screen_center().x
	if position.y > 240 or position.x-8 < camera-screen or position.x+8 > camera+screen:
		queue_free()
