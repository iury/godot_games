extends TextureRect

func _ready():
	update_counter()
	# warning-ignore:return_value_discarded
	GameData.connect("data_changed", self, "_on_data_changed")


func update_counter():
	if GameData.lives > 1:
		rect_size.x = 43*clamp(GameData.lives-1, 0, 5)
		show()
	else:
		hide()


func _on_data_changed(data, _value, _old_value):
	if data == 'lives':
		update_counter()
