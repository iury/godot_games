extends CanvasLayer

const Menu = preload("res://src/scenes/Menu.tscn")
const NameInputter = preload("res://src/misc/NameInputter.tscn")

var idx = -1

func _ready():
	var scores = GameData.high_scores
	if scores.size() < 10:
		for i in range(scores.size(), 10):
			scores.append(['AAA', (10-i+1)*10000])

	if GameData.score > 0:
		for i in range(scores.size()):
			if scores[i][1] <= GameData.score:
				idx = i
				break
	
	if idx >= 0:
		scores.insert(idx, ['   ', GameData.score])
		scores.resize(10)
		var inputter = NameInputter.instance()
		inputter.text = 'AAA'
		inputter.rect_position = Vector2(96, 232+idx*42)
		inputter.connect("finished", self, "_on_input_finished")
		add_child(inputter)

	$LabelNames.text = ''
	$LabelScores.text = ''
	for score in scores:
		$LabelNames.text += score[0] + "\n"
		$LabelScores.text += str(score[1]) + "\n"


func _on_input_finished(value):
	GameData.high_scores[idx][0] = value
	GameData.save()
	GameData.score = 0


func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel") or event.is_action_pressed("ui_accept"):
		get_tree().set_input_as_handled()
		if GameData.game_started:
			get_tree().current_scene.add_child(Menu.instance())
			queue_free()
		else:
			# warning-ignore:return_value_discarded
			get_tree().reload_current_scene()
			SoundLibrary.stop(SoundLibrary.Sounds.GAME_END)
