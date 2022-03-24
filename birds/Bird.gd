extends RigidBody2D

var drag_enabled = false setget set_drag_enabled

signal drag_started
signal released


func _physics_process(_delta):
	if mode == MODE_STATIC and drag_enabled:
		var pos = get_global_mouse_position()
		global_position = pos


func _on_Bird_input_event(_viewport, event, _shape_idx):
	if mode == MODE_STATIC and event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		self.drag_enabled = event.pressed


func _input(event):
	if mode == MODE_STATIC and event is InputEventMouseButton and event.button_index == BUTTON_LEFT and not event.pressed and drag_enabled:
		self.drag_enabled = false


func set_drag_enabled(value):
	var drag_started = not drag_enabled and value
	var released = drag_enabled and not value

	drag_enabled = value

	if drag_started:
		emit_signal("drag_started")
	if released:
		emit_signal("released")
