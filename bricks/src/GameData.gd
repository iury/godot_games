extends Node

signal data_changed(data, value, old_value)

var full_screen = false setget set_full_screen
var sfx = true setget set_sfx
var bgm = true setget set_bgm
var high_scores = [] setget set_high_scores
var score = 0 setget set_score
var game_started = false setget set_game_started
var level = 1 setget set_level
var lives = 3 setget set_lives
var bgcolor = null
var bricks = null

const FILE_NAME = 'user://bricks.dat'

func _ready():
	var file = File.new()
	if not file.file_exists(FILE_NAME):
		return
	file.open(FILE_NAME, File.READ)
	var data = file.get_var()
	self.set_deferred('full_screen', data.full_screen)
	self.set_deferred('sfx', data.sfx)
	self.set_deferred('bgm', data.bgm)
	self.high_scores = data.high_scores
	file.close()


func save():
	var file = File.new()
	file.open(FILE_NAME, File.WRITE)
	file.store_var({
		full_screen = full_screen,
		sfx = sfx,
		bgm = bgm,
		high_scores = high_scores,
	})
	file.close()


func set_full_screen(value):
	var ov = full_screen
	full_screen = value
	if ov != value:
		emit_signal("data_changed", "full_screen", value, ov)

func set_bgm(value):
	var ov = bgm
	bgm = value
	if ov != value:
		emit_signal("data_changed", "bgm", value, ov)

func set_sfx(value):
	var ov = sfx
	sfx = value
	if ov != value:
		emit_signal("data_changed", "sfx", value, ov)

func set_high_scores(value):
	var ov = high_scores
	high_scores = value
	if ov != value:
		emit_signal("data_changed", "high_score", value, ov)

func set_score(value):
	var ov = score
	score = value
	if ov != value:
		emit_signal("data_changed", "score", value, ov)

func set_game_started(value):
	var ov = game_started
	game_started = value
	if ov != game_started:
		emit_signal("data_changed", "game_started", value, ov)

func set_level(value):
	var ov = level
	level = value
	if ov != value:
		bricks = null
		emit_signal("data_changed", "level", value, ov)

func set_lives(value):
	var ov = lives
	lives = value
	if ov != lives:
		emit_signal("data_changed", "lives", value, ov)
