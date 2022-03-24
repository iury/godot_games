extends Node

enum Sounds {
	CLOCK,
	ERROR,
	GAME_OVER,
	MATCH,
	MUSIC,
	SELECT,
}

func play(sound):
	get_node(Sounds.keys()[sound]).play()

func stop(sound):
	get_node(Sounds.keys()[sound]).stop()
