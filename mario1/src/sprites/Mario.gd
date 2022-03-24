extends KinematicBody2D

const mario_normal = preload("res://src/materials/mario_normal.tres")
const mario_fp1 = preload("res://src/materials/mario_fp1.tres")
const mario_fp2 = preload("res://src/materials/mario_fp2.tres")
const mario_fp3 = preload("res://src/materials/mario_fp3.tres")
const mario_fp4 = preload("res://src/materials/mario_fp4.tres")

const Fire = preload("res://src/sprites/Fire.tscn")

var movable = true setget set_movable
var is_big = false
var was_on_air = false
var can_fire = false

var force_move_right = false
var face_direction
var velocity
var hold_gravity
var gravity

func _ready():
	reset_state()


func reset_blend_positions():
	$AnimationTree["parameters/Grow/blend_position"] = face_direction
	$AnimationTree["parameters/Idle/blend_position"] = Vector2(1, 0 if is_big else -1)
	$AnimationTree["parameters/Walk/blend_position"] = Vector2(face_direction, 1 if is_big else 0)
	$AnimationTree["parameters/Jump/blend_position"] = Vector2(face_direction, 1 if is_big else 0)
	$AnimationTree["parameters/Skid/blend_position"] = Vector2(face_direction, 1 if is_big else 0)


func reset_state():
	self.movable = true
	z_index = 0
	face_direction = 1
	velocity = Vector2.ZERO
	hold_gravity = 0
	gravity = 0x700
	force_move_right = false
	$Camera2D.limit_left = 0
	reset_blend_positions()
	$AnimationTree["parameters/playback"].travel("Idle")


func _physics_process(delta):
	if not movable: return

	var axis = Vector2(Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"), 0 - Input.get_action_strength("ui_down")).normalized()
	var acc_axis = 0 if velocity.x == 0 else velocity.x/abs(velocity.x)
	var run = Input.is_action_pressed("run") or Input.is_action_just_released("run")
	var shoot = Input.is_action_just_pressed("run")
	
	if force_move_right:
		axis.x = 1
		run = false
		shoot = false

	if shoot and can_fire:
		var fire = Fire.instance()
		fire.global_position = global_position + Vector2(8*face_direction, 0)
		get_tree().current_scene.add_child(fire)
	
	if axis.x != 0:
		face_direction = axis.x
		$AnimationTree["parameters/Walk/blend_position"] = Vector2(face_direction, 1 if is_big else 0)
	
	if axis.x != 0 and acc_axis == 0:
		# exit inertia
		if is_on_floor(): $AnimationTree["parameters/playback"].travel("Walk")
		velocity.x = axis.x*0x130

	elif axis.x != 0 and acc_axis == axis.x:
		# accelerate towards max speed
		if is_on_wall():
			velocity.x = axis.x*0x214
		elif is_on_floor():
			$AnimationTree["parameters/playback"].travel("Walk")
			if run:
				velocity.x += axis.x*0xe4
				velocity.x = clamp(velocity.x, -0x2900, 0x2900)
			else:
				velocity.x += axis.x*0x98
				velocity.x = clamp(velocity.x, -0x1900, 0x1900)
		elif not is_on_wall():
			velocity.x += axis.x * (0xe4 if velocity.x >= 0x1900 else 0x98)
			velocity.x = clamp(velocity.x, -0x2900, 0x2900)
	
	elif axis.x != 0 and acc_axis != axis.x:
		# skid
		if is_on_wall():
			velocity.x = axis.x*0x130
		elif is_on_floor():
			$AnimationTree["parameters/Skid/blend_position"] = Vector2(face_direction, 1 if is_big else 0)
			$AnimationTree["parameters/playback"].travel("Skid")
			velocity.x += axis.x * 0x1a0
			if abs(velocity.x) <= 0x900:
				velocity.x = axis.x * 0x2d0
		else:
			velocity.x += axis.x * (0xe4 if velocity.x >= 0x1900 else 0xd0)

	elif acc_axis != 0:
		# deaccelerate towards zero
		if acc_axis > 0:
			velocity.x = clamp(velocity.x-0xd0, 0, velocity.x)
		else:
			velocity.x = clamp(velocity.x+0xd0, velocity.x, 0)
	
	elif acc_axis == 0:
		# idle
		if is_on_floor():
			var y = -1
			if is_big: y = 1 if axis.y == -1 else 0
			$AnimationTree["parameters/Idle/blend_position"] = Vector2(face_direction, y)
			$AnimationTree["parameters/playback"].travel("Idle")
			
			if shoot and can_fire:
				$AnimationTree["parameters/Fire/blend_position"] = face_direction
				$AnimationTree["parameters/playback"].travel("Fire")
	
	# adjust walk/running speed animation
	if $AnimationTree["parameters/playback"].get_current_node() == 'Walk':
		$AnimatedSprite.speed_scale = 4 if abs(velocity.x) > 0x1900 else 1
	else:
		$AnimatedSprite.speed_scale = 1

	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			$AnimationTree["parameters/Jump/blend_position"] = Vector2(face_direction, 1 if is_big else 0)
			$AnimationTree["parameters/playback"].travel("Jump")
			
			if is_big:
				SoundLibrary.play(SoundLibrary.Sounds.BIG_JUMP)
			else:
				SoundLibrary.play(SoundLibrary.Sounds.SMALL_JUMP)
			
			if velocity.x < 0x1000:
				velocity.y = -0x4900
				hold_gravity = 0x200
				gravity = 0x700
			elif velocity.x < 0x2500:
				velocity.y = -0x47e0
				hold_gravity = 0x1e0
				gravity = 0x600
			else:
				velocity.y = -0x6180
				hold_gravity = 0x280
				gravity = 0x900
		
		else:
			velocity.y = 0
			if was_on_air: $AnimationTree["parameters/playback"].travel("Walk")

	if is_on_ceiling():
		velocity.y = int(velocity.y / 0x2000)

	# apply gravity
	velocity.y += clamp(hold_gravity if Input.is_action_pressed("jump") and velocity.y < 0 else gravity, -0x5000, 0x4000)
	
	# cannot move left from camera
	if velocity.x < 0 and position.x-8 <= $Camera2D.limit_left:
		velocity.x = 0

	was_on_air = not is_on_floor()

	# warning-ignore:return_value_discarded
	move_and_slide(velocity/0x1000/delta, Vector2.UP)
	var collisions = []
	for i in get_slide_count():
		collisions.append(get_slide_collision(i))

	while collisions.size() > 0:
		var collision = collisions.pop_back()

		if collision.collider.has_method("hit"):
			collision.collider.hit(self, collision.normal)
			hit(collision.collider, collision.normal)
			
			# little jump when stomping
			if velocity.y > 0 and was_on_air and not collision.collider.get_collision_layer_bit(0):
				velocity.y = -0x4900
				gravity = 0x700
				# warning-ignore:return_value_discarded
				move_and_slide(velocity/0x1000/delta, Vector2.UP)
				for i in get_slide_count():
					collisions.append(get_slide_collision(i))

	# move camera on mid point
	if position.x - 128 > $Camera2D.limit_left:
		$Camera2D.limit_left = clamp(position.x - 128, 0, $Camera2D.limit_right-256)
	
	if position.y > 256:
		died(false)


func set_movable(value):
	movable = value
	if not movable:
		$AnimationTree["parameters/playback"].travel("Idle")
	for enemy in get_tree().get_nodes_in_group("enemies"):
		enemy.frozen = not value


func hit(from, _normal):
	if from.get_collision_layer_bit(2) and get_collision_layer_bit(1) and not was_on_air:
		can_fire = false
		if is_big:
			SoundLibrary.play(SoundLibrary.Sounds.PIPE)
			self.movable = false
			is_big = false
			$AnimationTree["parameters/Shrink/blend_position"] = face_direction
			$AnimationTree["parameters/playback"].travel("Shrink")
			yield(get_tree().create_timer(1.8), "timeout")
			self.movable = true
			invincible_frames()
		else:
			died()


func invincible_frames():
	collision_layer = 0
	$Tween.interpolate_method(self, "flash_invincible", 0, 16, 1.2)
	$Tween.start()


func flash_invincible(v):
	if int(v) % 2 == 0:
		modulate = Color.white
	else:
		modulate = Color.transparent
	if v == 16:
		collision_layer = 0b11


func died(animate = true):
	SoundLibrary.stop_all()
	SoundLibrary.play(SoundLibrary.Sounds.DEATH)
	self.movable = false
	z_index = 999
	if animate: $AnimationTree["parameters/playback"].travel("Died")
	yield(get_tree().create_timer(3), "timeout")
	Mario.reset_state()
	Mario.is_big = false
	Mario.can_fire = false
	# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()


func grow():
	if not is_big:
		SoundLibrary.play(SoundLibrary.Sounds.POWERUP)
		self.movable = false
		is_big = true
		reset_blend_positions()
		$AnimationTree["parameters/playback"].travel("Grow")
		yield(get_tree().create_timer(0.9), "timeout")
		self.movable = true


func fire_power():
	if not can_fire:
		if is_big:
			SoundLibrary.play(SoundLibrary.Sounds.POWERUP)
			self.movable = false
			$AnimationTree.active = false
			$AnimatedSprite.playing = false
			$AnimationPlayer.playback_active = false
			$Tween.interpolate_method(self, "fire_power_animation", 0, 16, 0.8)
			$Tween.start()
			yield(get_tree().create_timer(0.8), "timeout")
			$AnimationTree.active = true
			$AnimatedSprite.playing = true
			$AnimationPlayer.playback_active = true
			self.movable = true
			can_fire = true
		else:
			grow()
	
	
func fire_power_animation(v):
	match int(v) % 4:
		0: $AnimatedSprite.material = mario_fp1
		1: $AnimatedSprite.material = mario_fp2
		2: $AnimatedSprite.material = mario_fp3
		3: $AnimatedSprite.material = mario_fp4


func rise():
	self.movable = false
	$Tween.interpolate_property(self, "global_position", global_position, global_position+Vector2(0, -12), 0.8)
	$Tween.start()
	yield(get_tree().create_timer(0.8), "timeout")
	self.movable = true


func enter_pipe(direction):
	reset_state()
	self.movable = false
	$Tween.interpolate_property(self, "global_position", global_position, global_position+direction, 0.8)
	$Tween.start()
	yield(get_tree().create_timer(0.8), "timeout")
	self.movable = true
