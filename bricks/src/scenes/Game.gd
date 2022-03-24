extends Node2D

const Brick = preload("res://src/sprites/Brick.tscn")
const SilverBrick = preload("res://src/sprites/SilverBrick.tscn")
const GameOver = preload("res://src/scenes/HighScores.tscn")
const PauseLayer = preload("res://src/scenes/PauseLayer.tscn")
const Menu = preload("res://src/scenes/Menu.tscn")

func _ready():
	randomize()
	OS.set_window_title("Bricks")
	
	if GameData.game_started:
		$LabelScore.text = str(GameData.score)
		# warning-ignore:return_value_discarded
		GameData.connect("data_changed", self, "_on_data_changed")

		if GameData.bricks:
			render_bricks()
		elif load_level():
			SoundLibrary.play(SoundLibrary.Sounds.START)
			render_bricks()

	else:
		var menu = Menu.instance()
		add_child(menu)


func load_level():
	var bgcolors = {
		B = Color(1/255.0, 0, 122/255.0),
		G = Color(9/255.0, 150/255.0, 2/255.0),
		R = Color(116/255.0, 0, 1/255.0),
		D = Color(1/255.0, 0, 122/255.0),
	}
	
	var file = File.new()
	var path = 'res://levels/%s.txt' % GameData.level
	if not file.file_exists(path):
		game_over()
		return false
	file.open(path, File.READ)
	
	var bg = file.get_line()
	GameData.bgcolor = bgcolors[bg]

	GameData.bricks = []
	while not file.eof_reached():
		var row = []
		var line = file.get_line()
		for brick in line:
			# warning-ignore:incompatible_ternary
			row.append(int(brick) if brick != ' ' else null)
		GameData.bricks.append(row)

	file.close()
	return true


func render_bricks():
	$BackgroundColor.color = GameData.bgcolor
	for j in GameData.bricks.size():
		for i in GameData.bricks[j].size():
			var brick: Node2D
			var color = GameData.bricks[j][i]
			if color == null:
				continue
			elif color == 0:
				brick = SilverBrick.instance()
			else:
				brick = Brick.instance()
				brick.color_offset = color
			brick.pos_i = i
			brick.pos_j = j
			brick.global_position = Vector2(45+39*i, 103+21*j)
			# warning-ignore:return_value_discarded
			brick.connect("destroyed", self, "_on_brick_destroyed")
			add_child(brick)


func pause():
	if not get_tree().paused:
		var layer = PauseLayer.instance()
		call_deferred('add_child', layer)


func game_over():
	GameData.game_started = false
	SoundLibrary.play(SoundLibrary.Sounds.GAME_END)
	var layer = GameOver.instance()
	add_child(layer)


func _on_ball_dead():
	var balls = get_tree().get_nodes_in_group("balls").size()
	if balls == 0:
		$Player.dead = true

		for bullet in get_tree().get_nodes_in_group("bullets"):
			bullet.queue_free()

		yield(get_tree().create_timer(2), "timeout")

		GameData.lives -= 1
		if GameData.lives > 0:
			# warning-ignore:return_value_discarded
			get_tree().reload_current_scene()
		else:
			game_over()


func _on_brick_destroyed():
	var bricks = get_tree().get_nodes_in_group("bricks")
	var cnt = bricks.size()
	for brick in bricks:
		if brick.color_offset == 9:
			cnt -= 1
	if cnt == 0:
		GameData.level += 1
		# warning-ignore:return_value_discarded
		get_tree().reload_current_scene()


func _on_data_changed(data, value, old_value):
	if data == 'score':
		$LabelScore.text = str(value)
		if value/20000 > old_value/20000:
			GameData.lives += 1
	elif data == 'lives' and value > old_value:
		SoundLibrary.play(SoundLibrary.Sounds.LIFE)


func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		get_tree().set_input_as_handled()
		pause()
	elif event.is_action_pressed("ui_cancel"):
		get_tree().set_input_as_handled()
		var layer = Menu.instance()
		call_deferred('add_child', layer)


func _notification(what):
	if what == NOTIFICATION_WM_FOCUS_OUT:
		pause()
	if what == NOTIFICATION_WM_QUIT_REQUEST:
		GameData.save()

