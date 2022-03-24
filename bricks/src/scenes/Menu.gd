extends CanvasLayer

onready var HighScores = load("res://src/scenes/HighScores.tscn")


func _ready():
	get_tree().paused = true
	$MainButtons.show()
	$Settings.hide()

	if GameData.game_started:
		$MainButtons/BtnContinue.visible = true
		$MainButtons/BtnContinue.grab_focus()
	else:
		$MainButtons/BtnContinue.visible = false
		$MainButtons/BtnNewGame.grab_focus()


func _on_BtnContinue_pressed():
	get_tree().paused = false
	queue_free()


func _on_BtnNewGame_pressed():
	GameData.score = 0
	GameData.level = 1
	GameData.bricks = null
	GameData.game_started = true
	SoundLibrary.stop_all()
	get_tree().paused = false
	# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()


func _on_BtnHighScores_pressed():
	get_tree().current_scene.add_child(HighScores.instance())
	queue_free()


func _on_BtnSettings_pressed():
	$Settings/BtnToggleSound.text = 'Mute: %s' % ('Off' if GameData.sfx else 'On')
	$MainButtons.hide()
	$Settings.show()
	$Settings/BtnToggleFS.grab_focus()


func _on_BtnQuitGame_pressed():
	GameData.save()
	get_tree().quit()


func _on_BtnToggleFS_pressed():
	OS.window_fullscreen = !OS.window_fullscreen


func _on_BtnToggleSound_pressed():
	GameData.sfx = !GameData.sfx
	$Settings/BtnToggleSound.text = 'Mute: %s' % ('Off' if GameData.sfx else 'On')


func _on_BtnGoBack_pressed():
	$MainButtons.show()
	$Settings.hide()
	$MainButtons/BtnSettings.grab_focus()


func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().set_input_as_handled()
		if $Settings.visible:
			$Settings/BtnGoBack.emit_signal("pressed")
		elif $MainButtons/BtnContinue.visible:
			$MainButtons/BtnContinue.emit_signal("pressed")
		else:
			$MainButtons/BtnQuitGame.emit_signal("pressed")
