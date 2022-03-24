extends KinematicBody2D

export(bool) var movable = false

var is_default = true setget set_is_default
var is_wide = false setget set_is_wide
var can_shoot = false setget set_can_shoot
var dead = false setget set_dead

var velocity = Vector2.ZERO

onready var _screen_size = get_viewport_rect()

const Bullet = preload("res://src/sprites/Bullet.tscn")


func _physics_process(delta):
	if movable:
		var travel = velocity * delta
		var collision = move_and_collide(travel)
		if collision:
			travel = collision.travel
		
		for ball in get_tree().get_nodes_in_group("balls"):
			if ball.is_captured:
				ball.global_position += travel


func _unhandled_input(event):
	if movable:
		velocity = Vector2(Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"), 0) * _screen_size.size.x
		if can_shoot and event.is_action_pressed("ui_accept"):
			var b1 = Bullet.instance()
			var b2 = Bullet.instance()
			b1.global_position = global_position + Vector2(-10, -20)
			b2.global_position = global_position + Vector2(10, -20)
			get_tree().current_scene.add_child(b1)
			get_tree().current_scene.add_child(b2)
			SoundLibrary.play(SoundLibrary.Sounds.FIRE)


func set_dead(value):
	dead = value
	if dead:
		movable = false
		collision_layer = 0
		$AnimationTree['parameters/playback'].travel('explode')
		SoundLibrary.play(SoundLibrary.Sounds.DEAD)


func set_is_default(value):
	is_default = value
	can_shoot = false
	is_wide = false
	if is_default:
		$AnimationTree['parameters/playback'].travel('pulsate')


func set_is_wide(value):
	is_wide = value
	is_default = false
	can_shoot = false
	if is_wide:
		$AnimationTree['parameters/playback'].travel('pulsate_wide')


func set_can_shoot(value):
	can_shoot = value
	is_default = false
	is_wide = false
	if can_shoot:
		$AnimationTree['parameters/playback'].travel('pulsate_laser')
