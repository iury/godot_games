extends CanvasLayer

func _ready():
	if GameData.game_started:
		$MainButtons/BtnContinue.show()
		$MainButtons/BtnContinue.grab_focus()
		$LabelTitle.hide()
		$LabelAux.hide()
		$LabelPaused.show()
	else:
		$MainButtons/BtnContinue.hide()
		$MainButtons/BtnNewGame.grab_focus()

	$LabelHighScore.text = 'High Score: %s' % GameData.high_score
	# warning-ignore:return_value_discarded
	GameData.connect("data_changed", self, "_on_data_changed")
	_on_data_changed(null, null)


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().set_input_as_handled()
		if $MainButtons.visible:
			if $MainButtons/BtnContinue.visible:
				$MainButtons/BtnContinue.emit_signal('pressed')
			else:
				$MainButtons/BtnQuitGame.emit_signal('pressed')
		else:
			$SettingsButtons/BtnGoBack.emit_signal('pressed')


func _on_button_focus_exited():
	SoundLibrary.play(SoundLibrary.Sounds.CURSOR)


func _on_data_changed(_data, _value):
	var btn = $SettingsButtons/BtnSounds
	if GameData.bgm and GameData.sfx:
		btn.text = 'Music & Effects'
	elif GameData.sfx:
		btn.text = 'Effects Only'
	else:
		btn.text = 'No Sounds'


func _on_BtnContinue_pressed():
	get_tree().paused = false
	queue_free()


func _on_BtnNewGame_pressed():
	GameData.game_started = true
	GameData.score = 0
	get_tree().paused = false
	# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()
	queue_free()


func _on_BtnSettings_pressed():
	$MainButtons.hide()
	$SettingsButtons.show()
	$SettingsButtons/BtnToggleFS.grab_focus()


func _on_BtnQuitGame_pressed():
	GameData.save()
	get_tree().quit()


func _on_BtnToggleFS_pressed():
	OS.window_fullscreen = !OS.window_fullscreen


func _on_BtnSounds_pressed():
	if GameData.bgm and GameData.sfx:
		GameData.bgm = false
	elif GameData.sfx:
		GameData.sfx = false
	else:
		GameData.bgm = true
		GameData.sfx = true


func _on_BtnGoBack_pressed():
	$MainButtons.show()
	$SettingsButtons.hide()
	if $MainButtons/BtnContinue.visible:
		$MainButtons/BtnContinue.grab_focus()
	else:
		$MainButtons/BtnNewGame.grab_focus()
