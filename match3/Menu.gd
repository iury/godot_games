extends Node2D


func _ready():
	SoundLibrary.play(SoundLibrary.Sounds.MUSIC)


func _on_Timer_timeout():
	$Title['custom_colors/font_color'] = Color(randf(), randf(), randf())


func _on_BtnStart_pressed():
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Board.tscn")


func _on_BtnToggleFS_pressed():
	OS.window_fullscreen = !OS.window_fullscreen
	SoundLibrary.play(SoundLibrary.Sounds.SELECT)


func _on_BtnToggleMute_pressed():
	AudioServer.set_bus_mute(0, !AudioServer.is_bus_mute(0))
	$BtnToggleMute.text = "Mute: %s" % ('On' if AudioServer.is_bus_mute(0) else 'Off')
	SoundLibrary.play(SoundLibrary.Sounds.SELECT)
