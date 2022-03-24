extends KinematicBody2D

signal dead

export(float) var speed = 240
export(bool) var can_capture = false
export(bool) var is_captured = false setget set_is_captured

onready var screen_size = get_viewport_rect()

var velocity = Vector2.ZERO


func _init():
	randomize_up_vector()


func _ready():
	# warning-ignore:return_value_discarded
	self.connect("dead", get_tree().current_scene, "_on_ball_dead")


func randomize_up_vector():
	var direction = 1 if randi() % 2 == 0 else -1
	velocity = Vector2(0, -1).rotated(deg2rad(rand_range(25, 35) * direction))


func _physics_process(delta):
	if not is_captured:
		var collision = move_and_collide(velocity * speed * delta)
		if collision:
			velocity = velocity.bounce(collision.normal)

			# collided on the player
			if collision.collider.get_collision_layer_bit(1):
				var pos = collision.position - collision.collider.global_position
				speed = clamp(speed+10, 240, 600)
				var w = 119 if collision.collider.is_wide else 79
				var angle = PI * clamp(pos.x/w, -0.3, 0.3) - PI/2
				velocity = Vector2(cos(angle), sin(angle))
				
				if can_capture:
					capture(collision.collider)
				else:
					SoundLibrary.play(SoundLibrary.Sounds.UP)

			# collided on a brick
			if collision.collider.get_collision_layer_bit(3):
				speed = clamp(speed+10, 240, 600)
				collision.collider.hit(false)
			
			else:
				SoundLibrary.play(SoundLibrary.Sounds.CATCH)
		
		if global_position.y > screen_size.size.y + 5:
			remove_from_group("balls")
			emit_signal("dead")
			queue_free()


func _unhandled_input(event):
	if is_captured and get_tree().get_nodes_in_group("player")[0].movable and event.is_action_pressed("ui_accept"):
		self.is_captured = false


func capture(player):
	global_position.y = player.global_position.y-20
	is_captured = true
	SoundLibrary.play(SoundLibrary.Sounds.CATCH)


func set_is_captured(value):
	var ov = is_captured
	is_captured = value
	if ov and !is_captured:
		SoundLibrary.play(SoundLibrary.Sounds.UP)
