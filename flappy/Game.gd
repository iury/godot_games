extends Node2D

const Menu = preload("res://Menu.tscn")
const Pipe = preload("res://Pipe.tscn")
const GameOver = preload("res://GameOver.tscn")

func _ready():
	randomize()
	OS.set_window_title("Flappy Duck")
	
	# warning-ignore:return_value_discarded
	GameData.connect("data_changed", self, "_on_data_changed")
	if not GameData.game_started:
		$Player.dead = true
		$Player.hide()
		$Background.pause_mode = Node.PAUSE_MODE_PROCESS
		pause()


func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		GameData.save()
	elif what == MainLoop.NOTIFICATION_WM_FOCUS_OUT:
		SoundLibrary.get_node("MUSIC").stream_paused = true
		get_tree().paused = true
	elif what == MainLoop.NOTIFICATION_WM_FOCUS_IN:
		SoundLibrary.get_node("MUSIC").stream_paused = false
		get_tree().paused = false


func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		pause()


func pause():
	get_tree().paused = true
	var menu = Menu.instance()
	add_child(menu)


func _on_data_changed(data, value):
	if data == 'score':
		$CanvasScore/LabelScore.text = 'Score: %s' % value
		if value > 0:
			SoundLibrary.play(SoundLibrary.Sounds.SCORE)


func _on_TimerSpawnPipes_timeout():
	var pipe1 = Pipe.instance()
	var pipe2 = Pipe.instance()
	
	var offset = rand_range(0, 150)
	var gap = rand_range(80, 150)
	pipe1.global_position = $SpawnPoint.global_position - Vector2(0, 288-offset)
	pipe2.global_position = $SpawnPoint.global_position + Vector2(0, offset+gap)
	
	pipe1.flip()
	add_child(pipe1)
	add_child(pipe2)


func _on_Player_hit():
	GameData.game_started = false
	$TimerSpawnPipes.stop()
	$Background.velocity = Vector2.ZERO
	SoundLibrary.play(SoundLibrary.Sounds.HIT)
	if GameData.score > GameData.high_score:
		GameData.high_score = GameData.score
	var game_over = GameOver.instance()
	add_child(game_over)
