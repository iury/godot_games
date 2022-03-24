extends CanvasLayer

var can_restart = false

func _ready():
	$LabelScore.text = "Score: %s" % GameData.score
	$LabelHighScore.text = "High Score: %s" % GameData.high_score


func _input(event):
	if can_restart and event.is_action_pressed("ui_accept") or event.is_action_pressed("ui_cancel"):
		get_tree().set_input_as_handled()
		GameData.score = 0
		GameData.game_started = true
		# warning-ignore:return_value_discarded
		get_tree().reload_current_scene()


func _on_Timer_timeout():
	can_restart = true
