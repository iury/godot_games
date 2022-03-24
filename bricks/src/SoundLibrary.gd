extends Node

enum Sounds {
	BOUNCE,
	CATCH,
	DEAD,
	DOWN,
	FIRE,
	GAME_END,
	LIFE,
	POWERUP,
	SELECT,
	START,
	UP,
}


func _ready():
	# warning-ignore:return_value_discarded
	GameData.connect("data_changed", self, "_on_data_changed")


func play(sound):
	get_node(Sounds.keys()[sound]).play()


func stop(sound):
	get_node(Sounds.keys()[sound]).stop()


func stop_all():
	for sound in Sounds.values():
		stop(sound)


func _on_data_changed(data, value, _old_value):
	if data == 'sfx':
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), !value)
