extends Node

enum Sounds {MUSIC, CURSOR, HIT, SCORE, WING}


func _ready():
	# warning-ignore:return_value_discarded
	GameData.connect("data_changed", self, "_on_data_changed")


func play(sound):
	get_node(Sounds.keys()[sound]).play()


func stop(sound):
	get_node(Sounds.keys()[sound]).stop()


func _on_data_changed(data, value):
	if data == 'bgm':
		if value:
			play(Sounds.MUSIC)
		else:
			stop(Sounds.MUSIC)
		AudioServer.set_bus_mute(AudioServer.get_bus_index("bgm"), !value)
	elif data == 'sfx':
		AudioServer.set_bus_mute(AudioServer.get_bus_index("sfx"), !value)
