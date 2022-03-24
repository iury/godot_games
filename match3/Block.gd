tool
extends Button

export(int) var color = 0 setget set_color
export(Vector2) var grid_position setget set_grid_position

signal swap

var corner


func set_color(value):
	color = value
	$Sprite.frame = value


func _on_Button_toggled(button_pressed):
	var other_block

	if button_pressed:
		for block in get_tree().get_nodes_in_group("blocks"):
			if block != self and block.pressed:
				other_block = block
				block.pressed = false
				break

	if other_block:
		self.pressed = false
		var p1 = grid_position
		var p2 = other_block.grid_position
		if p1.distance_to(p2) == 1:
			var b1 = Grid.table[p1.y][p1.x]
			var b2 = Grid.table[p2.y][p2.x]
			emit_signal("swap", b1, b2)

	else:
		$Selected.visible = button_pressed


func appear(vCorner):
	corner = vCorner
	set_global_position(corner + Vector2(grid_position.x*32, grid_position.y*32))
	rect_scale = Vector2(0.1, 0.1)
	rect_position += Vector2(16, 16)
	$Tween.interpolate_property(self, "rect_scale", rect_scale, Vector2(1, 1), 0.1)
	$Tween.interpolate_property(self, "rect_position", rect_position, rect_position - Vector2(16, 16), 0.1)
	$Tween.call_deferred('start')


func destroy():
	$Tween.interpolate_property(self, "rect_scale", rect_scale, Vector2(0.1, 0.1), 0.2)
	$Tween.interpolate_property(self, "rect_position", rect_position, rect_position + Vector2(16, 16), 0.2)
	$Tween.start()


func set_grid_position(value):
	var ov = grid_position
	grid_position = value
	if ov != grid_position and corner:
		$Tween.interpolate_property(self, "rect_position", rect_position, corner + Vector2(grid_position.x*32, grid_position.y*32), 0.2)
		$Tween.start()
