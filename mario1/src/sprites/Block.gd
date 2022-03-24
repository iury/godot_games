extends StaticBody2D

enum BlockTypes {NORMAL, POWERUP, LIFE}

export(BlockTypes) var type = BlockTypes.NORMAL

const Mushroom = preload("res://src/sprites/Mushroom.tscn")
const Flower = preload("res://src/sprites/Flower.tscn")
const Life = preload("res://src/sprites/Life.tscn")

var was_hit = false


func _ready():
	if modulate != Color.white:
		$CollisionShape2D.one_way_collision = true


func hit(from, _normal):
	if from == Mario and from.is_on_ceiling() and not was_hit:
		$CollisionShape2D.one_way_collision = false
		modulate = Color.white
		was_hit = true
		$AnimatedSprite.animation = 'solid'
		set_collision_layer_bit(4, true)
		position.y -= 4

		var powerup
		match type:
			BlockTypes.NORMAL:
				$CoinAnimation.play("default")
			BlockTypes.POWERUP:
				if Mario.is_big:
					powerup = Flower.instance()
				else:
					powerup = Mushroom.instance()
			BlockTypes.LIFE:
				powerup = Life.instance()
		
		if powerup:
			SoundLibrary.play(SoundLibrary.Sounds.POWERUP_APPEARS)
			powerup.global_position = global_position + Vector2(0, -16)
			powerup.call_deferred('rise')
			get_parent().add_child(powerup)
		else:
			SoundLibrary.play(SoundLibrary.Sounds.COIN)

		yield(get_tree().create_timer(0.1), "timeout")
		set_collision_layer_bit(4, false)
		position.y += 2
		yield(get_tree().create_timer(0.1), "timeout")
		position.y += 2
