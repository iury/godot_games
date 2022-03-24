extends Node2D

const Block = preload("res://Block.tscn")
const GamePaused = preload("res://GamePaused.tscn")

var timedout = false setget set_timedout
var time_left = 60 setget set_time_left
var score = 0 setget set_score


func _ready():
	$BtnRestart.emit_signal("pressed")


func new_board():
	for block in get_tree().get_nodes_in_group("blocks"):
		block.destroy()
		block.queue_free()
	Grid.new_game()
	for y in Grid.table.size():
		for x in Grid.table[y].size():
			var color = Grid.table[y][x].color
			Grid.table[y][x].block = create_block(color, x, y)


func create_block(color, x, y):
	var block = Block.instance()
	block.color = color
	block.grid_position = Vector2(x, y)
	block.connect("swap", self, "_on_swap")
	block.appear($BoardCorner.position)
	get_tree().current_scene.add_child(block)
	return block


func enable_clicks():
	for block in get_tree().get_nodes_in_group("blocks"):
		block.disabled = false


func disable_clicks():
	for block in get_tree().get_nodes_in_group("blocks"):
		block.pressed = false
		block.disabled = true


func _on_swap(b1, b2):
	var p1 = b1.block.grid_position
	var p2 = b2.block.grid_position
	b1.block.grid_position = p2
	b2.block.grid_position = p1
	
	disable_clicks()
	yield(get_tree().create_timer(0.3), "timeout")

	if Grid.swap(p1, p2):
		process_matches()
		enable_clicks()
	
	else:
		SoundLibrary.play(SoundLibrary.Sounds.ERROR)
		yield(get_tree().create_timer(0.2), "timeout")
		b1.block.grid_position = p1
		b2.block.grid_position = p2
		yield(get_tree().create_timer(0.3), "timeout")
		enable_clicks()


func process_matches():
	var matches = Grid.matches()
	while matches.size() > 0:
		SoundLibrary.play(SoundLibrary.Sounds.MATCH)

		var items = []
		for m in matches:
			for x in range(m[0].x, m[1].x+1):
				var item = Grid.table[m[0].y][x]
				if !items.has(item):
					items.append(item)
			for y in range(m[0].y, m[1].y+1):
				var item = Grid.table[y][m[0].x]
				if !items.has(item):
					items.append(item)

		self.score += matches.size()
		self.time_left += items.size()
		
		var blocks = []
		for item in items:
			blocks.append(item.block)
			item.block.destroy()
			item.color = null
			item.block = null

		yield(get_tree().create_timer(0.2), "timeout")
		for block in blocks:
			block.queue_free()

		var filled_items = Grid.fill()
		yield(get_tree().create_timer(0.2), "timeout")

		for item in filled_items:
			item.block = create_block(item.color, item.x, item.y)

		matches = Grid.matches()
	
	if not Grid.validate():
		new_board()


func _on_Timer_timeout():
	self.time_left -= 1
	if time_left <= 10:
		SoundLibrary.play(SoundLibrary.Sounds.CLOCK)


func _on_BtnRestart_pressed():
	self.timedout = false
	self.time_left = 60
	self.score = 0
	new_board()


func set_timedout(value):
	timedout = value
	$BtnRestart.visible = value
	if value:
		SoundLibrary.play(SoundLibrary.Sounds.GAME_OVER)
		$Timer.stop()
		disable_clicks()
	else:
		$Timer.start()


func set_score(value):
	score = value
	$LabelScore.text = str(value)


func set_time_left(value):
	if not timedout:
		time_left = value
		$LabelTimer.text = str(value)
		if value <= 0:
			self.timedout = true


func pause():
	var layer = GamePaused.instance()
	add_child(layer)
	get_tree().paused = true


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().set_input_as_handled()
		pause()


func _notification(what):
	if what == NOTIFICATION_WM_FOCUS_OUT:
		call_deferred('pause')
