extends Area2D

export(String) var level
export(String) var direction
export(String) var spawn_point

var cnt = -1
var vector
var expected_direction
var adjust


func _ready():
	# warning-ignore:return_value_discarded
	self.connect("body_entered", self, "_on_PipeEntry_body_entered")
	# warning-ignore:return_value_discarded
	self.connect("body_exited", self, "_on_PipeEntry_body_exited")
	
	vector = Vector2(0, 32)
	expected_direction = "ui_down"
	adjust = Vector2(global_position.x+2, global_position.y-16)
	
	if direction == "RIGHT":
		$CollisionShape2D.rotation_degrees = 90
		expected_direction = "ui_right"
		vector = Vector2(16, 0)
		adjust = Vector2(global_position.x-8, global_position.y-8)


func _physics_process(_delta):
	if cnt >= 0 and Input.is_action_pressed(expected_direction) and Mario.movable:
		cnt += 1
		if cnt > 10:
			cnt = -1
			SoundLibrary.play(SoundLibrary.Sounds.PIPE)
			Mario.get_node("Camera2D").current = false
			Mario.global_position = adjust
			Mario.enter_pipe(vector)
			yield(get_tree().create_timer(0.8), "timeout")
			Mario.get_node("Camera2D").current = true
			GameData.level = load(level)
			GameData.spawn_point = spawn_point
			# warning-ignore:return_value_discarded
			get_tree().reload_current_scene()


func _on_PipeEntry_body_entered(body):
	if body == Mario:
		cnt = 0


func _on_PipeEntry_body_exited(body):
	if body == Mario:
		cnt = -1
