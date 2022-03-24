extends StaticBody2D

signal destroyed

export(int) var hp = 1
export(int) var color_offset = 0
export(int) var pos_i
export(int) var pos_j

const Powerup = preload("res://src/sprites/Powerup.tscn")


func _ready():
	add_to_group("bricks")


func hit(from_bullet):
	if is_queued_for_deletion(): return
	hp -= 1 if not from_bullet else hp
	if hp == 0:
		GameData.bricks[pos_j][pos_i] = null
		SoundLibrary.play(SoundLibrary.Sounds.DOWN)
		remove_from_group("bricks")
		emit_signal("destroyed")
		may_spawn_powerup()
		queue_free()
	elif hp > 0:
		SoundLibrary.play(SoundLibrary.Sounds.BOUNCE)


func may_spawn_powerup():
	var powerups = get_tree().get_nodes_in_group("powerups")
	if powerups.size() == 0 and randi() % 3 == 0:
		var sprite = Powerup.instance()
		sprite.global_position = global_position
		sprite.powerup = randi() % 6
		get_tree().current_scene.add_child(sprite)
