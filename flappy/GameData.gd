extends Node

signal data_changed(data, value)

export(bool) var full_screen = false setget set_full_screen
export(bool) var sfx = true setget set_sfx
export(bool) var bgm = true setget set_bgm
export(float) var high_score = 0 setget set_high_score
export(float) var score = 0 setget set_score

const FILE_NAME = 'user://flappy.duck'

var game_started = false

func _ready():
	var file = File.new()
	if not file.file_exists(FILE_NAME):
		return
	file.open(FILE_NAME, File.READ)
	var data = parse_json(file.get_line())
	self.set_deferred('full_screen', data.full_screen)
	self.set_deferred('sfx', data.sfx)
	self.set_deferred('bgm', data.bgm)
	self.high_score = data.high_score
	file.close()


func save():
	var file = File.new()
	file.open(FILE_NAME, File.WRITE)
	file.store_line(to_json({
		full_screen = full_screen,
		sfx = sfx,
		bgm = bgm,
		high_score = high_score,
	}))
	file.close()


func set_full_screen(value):
	full_screen = value
	emit_signal("data_changed", "full_screen", value)

func set_bgm(value):
	bgm = value
	emit_signal("data_changed", "bgm", value)

func set_sfx(value):
	sfx = value
	emit_signal("data_changed", "sfx", value)

func set_high_score(value):
	high_score = value
	emit_signal("data_changed", "high_score", value)

func set_score(value):
	score = value
	emit_signal("data_changed", "score", value)
