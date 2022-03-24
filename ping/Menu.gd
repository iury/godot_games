extends Node

onready var btnContinue = $Panel/BtnContinue

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	btnContinue.visible = get_tree().current_scene != self
	if btnContinue.visible:
		btnContinue.grab_focus()
	else:
		$Panel/BtnNewGame.grab_focus()


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if btnContinue.visible:
			btnContinue.emit_signal('pressed')
		else:
			$Panel/BtnQuit.emit_signal('pressed')


func _on_BtnNewGame_pressed():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	if get_tree().current_scene == self:
		# warning-ignore:return_value_discarded
		get_tree().change_scene("res://Game.tscn")
	else:
		# warning-ignore:return_value_discarded
		get_tree().reload_current_scene()
		get_tree().paused = false


func _on_btn_focus_entered():
	$Panel/BtnFocused.play()


func _on_BtnToggle_pressed():
	OS.window_fullscreen = !OS.window_fullscreen


func _on_BtnQuit_pressed():
	get_tree().quit()


func _on_BtnContinue_pressed():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	get_tree().paused = false
	queue_free()
