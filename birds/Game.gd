extends Node2D

onready var bird = $Bird
onready var birdSlingPosition = $Bird/SlingPosition
onready var releaseCenter = $Slingshot/ReleaseCenter
onready var slingshotFrontLine = $Slingshot/FrontLine
onready var slingshotBackLine = $Slingshot/BackLine
onready var trajectory = $Trajectory
onready var pig = $Pig


func _physics_process(_delta):
	if bird.mode == RigidBody2D.MODE_STATIC:
		var backPosStart = slingshotBackLine.global_position
		var frontPosStart = slingshotFrontLine.global_position
		slingshotBackLine.visible = true
		slingshotFrontLine.visible = true
		slingshotBackLine.points[1] = birdSlingPosition.global_position - backPosStart
		slingshotFrontLine.points[1] = birdSlingPosition.global_position - frontPosStart
		trajectory.global_position = bird.global_position
		trajectory.impulse = (releaseCenter.global_position - bird.global_position) * 5


func _on_Bird_drag_started():
	trajectory.visible = true


func _on_Bird_released():
	slingshotBackLine.visible = false
	slingshotFrontLine.visible = false
	trajectory.visible = false
	bird.mode = RigidBody2D.MODE_RIGID
	bird.apply_impulse(Vector2.ZERO, (releaseCenter.global_position - bird.global_position) * 5)


func reset_bird():
	$Timer.stop()
	bird.mode = RigidBody2D.MODE_STATIC
	bird.rotation_degrees = 0
	bird.global_position = Vector2(163, 473)


func _on_VisibilityNotifier2D_screen_exited():
	call_deferred('reset_bird')


func _on_Timer_timeout():
	call_deferred('reset_bird')


func _on_Bird_sleeping_state_changed():
	if bird.sleeping:
		call_deferred('reset_bird')


func _on_Bird_body_entered(_body):
	if bird.mode == RigidBody2D.MODE_RIGID:
		$Timer.start()


func _on_Pig_body_entered(body):
	if body is StaticBody2D or pig.get_linear_velocity().length() > 50 or body.get_linear_velocity().length() > 50:
		pig.queue_free()


func _on_Button_pressed():
	# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()
