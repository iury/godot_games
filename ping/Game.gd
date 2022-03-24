extends Node2D

const Ball = preload("res://Ball.tscn")
const MenuScene = preload("res://Menu.tscn")

var score1 = 0
var score2 = 0
var game_over = false

onready var screen_size = get_viewport_rect().size
onready var player1 = $Player1
onready var player2 = $Player2

func _ready():
	randomize()
	OS.set_window_title("PiNG!")
	
	var ball = Ball.instance()
	ball.position = Vector2(6, 0)
	player1.add_child(ball)


func _draw():
	draw_rect(Rect2(Vector2.ZERO, screen_size), Color.black)
	for i in range(screen_size.y/16):
		draw_rect(Rect2(
			Vector2(screen_size.x/2-1, i*16+4),
			Vector2(2, 8)
		), Color.white)


func _unhandled_input(event):
	if has_node("Help") and event.is_action_pressed("ui_accept"):
		remove_child($Help)
	elif event.is_action_pressed("ui_cancel"):
		get_tree().paused = true
		var menu = MenuScene.instance()
		add_child(menu)


func _on_player1_scored(_body):
	$Score.play()
	score1 += 1
	update_scores()
	var ball = Ball.instance()
	ball.position = Vector2(6, 0)
	player1.call_deferred('add_child', ball)


func _on_player2_scored(_body):
	$Score.play()
	score2 += 1
	update_scores()
	var ball = Ball.instance()
	ball.position = Vector2(-6, 0)
	player2.call_deferred('add_child', ball)


func _on_ball_exited(body):
	body.queue_free()


func update_scores():
	$Score1.text = str(score1)
	$Score2.text = str(score2)
	if score1 == 10 or score2 == 10:
		game_over = true
		get_tree().paused = true
		$LabelGameOver.text = "Player %s won!" % (1 if score1 == 10 else 2)
		$LabelGameOver.visible = true
		$TimerNewGame.start()
	else:
		game_over = false
		get_tree().paused = false
		$LabelGameOver.visible = false


func _on_TimerNewGame_timeout():
	score1 = 0
	score2 = 0
	update_scores()
