extends KinematicBody2D

export(String) var key_up
export(String) var key_down

func _physics_process(_delta):
	# warning-ignore:return_value_discarded
	move_and_slide(Vector2(0, Input.get_action_strength(key_down) - Input.get_action_strength(key_up)) * 320)
