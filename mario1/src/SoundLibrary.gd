extends Node

enum Sounds {
	BIG_JUMP,
	BRICK_SMASH,
	BUMP,
	COIN,
	DEATH,
	FLAGPOLE,
	INVINCIBLE,
	KICK,
	MAIN_THEME,
	PIPE,
	POWERUP,
	POWERUP_APPEARS,
	SMALL_JUMP,
	STAGE_CLEAR,
	STOMP,
	UNDERWORLD,
	UP,
	FIRE,
}


func play(sound):
	get_node(Sounds.keys()[sound]).play()


func stop(sound):
	get_node(Sounds.keys()[sound]).stop()


func stop_all():
	for sound in Sounds.values():
		stop(sound)
