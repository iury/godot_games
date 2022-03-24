extends CanvasLayer

func _ready():
	get_tree().paused = true

func unpause():
	get_tree().paused = false
	queue_free()

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel") or event.is_action_pressed("pause"):
		get_tree().set_input_as_handled()
		unpause()

func _notification(what):
	if what == NOTIFICATION_WM_FOCUS_IN:
		unpause()
