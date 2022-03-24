extends KinematicBody2D

const Ball = preload("res://src/sprites/Ball.tscn")

enum Powerups {
	CATCH,
	DUPLICATE,
	EXPAND,
	LIFE,
	LASER,
	SLOW,
}

export(Powerups) var powerup

onready var _screen_size = get_viewport_rect()

func _ready():
	$AnimatedSprite.animation = Powerups.keys()[powerup]
	$AnimatedSprite.frame = 0
	$AnimatedSprite.play()


func _physics_process(delta):
	var collision = move_and_collide(Vector2.DOWN * 120 * delta)
	if collision:
		apply_powerup(collision.collider)
		queue_free()
	
	if global_position.y > _screen_size.size.y + 5:
		queue_free()


func release_captured_balls():
	var balls = get_tree().get_nodes_in_group("balls")
	for ball in balls:
		ball.can_capture = false
		ball.is_captured = false


func apply_powerup(player):
	var balls = get_tree().get_nodes_in_group("balls")

	match powerup:
		Powerups.LIFE:
			GameData.lives += 1
		
		Powerups.SLOW:
			release_captured_balls()
			for ball in balls:
				ball.speed = 240
		
		Powerups.LASER:
			release_captured_balls()
			player.can_shoot = true
			SoundLibrary.play(SoundLibrary.Sounds.POWERUP)
		
		Powerups.EXPAND:
			release_captured_balls()
			player.is_wide = true
			SoundLibrary.play(SoundLibrary.Sounds.POWERUP)
		
		Powerups.CATCH:
			if player.can_shoot:
				player.is_default = true
			for ball in balls:
				ball.can_capture = true
			SoundLibrary.play(SoundLibrary.Sounds.CATCH)
		
		Powerups.DUPLICATE:
			release_captured_balls()
			var scene = get_tree().current_scene
			for ball in balls:
				var b1 = ball.duplicate()
				var b2 = ball.duplicate()
				scene.call_deferred('add_child', b1)
				scene.call_deferred('add_child', b2)
