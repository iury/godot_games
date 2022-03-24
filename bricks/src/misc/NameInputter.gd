extends Label

signal finished(value)

var pos = 0
var blink = false
onready var value = text.substr(0)


func _ready():
	pass


func _on_TimerBlink_timeout():
	if pos < 3:
		text[pos] = ' ' if blink else value[pos]
		blink = !blink


func _input(event):
	if pos == 4: return
	text = value

	if event.is_action_pressed("ui_accept"):
		get_tree().set_input_as_handled()
		pos += 1
		if pos == 4:
			$TimerBlink.stop()
			emit_signal("finished", value)
			self["custom_colors/font_color"] = Color.white

	elif event.is_action_pressed("ui_cancel"):
		get_tree().set_input_as_handled()
		if pos > 0:
			pos -= 1


func _unhandled_key_input(event):
	if event.pressed and pos < 4:
		var letter = OS.get_scancode_string(event.scancode).to_upper()
		if letter.length() == 1:
			get_tree().set_input_as_handled()
			value[pos] = letter
			pos += 1
