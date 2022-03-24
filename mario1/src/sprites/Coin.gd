extends Area2D


func _ready():
	# warning-ignore:return_value_discarded
	self.connect("body_entered", self, "_on_body_entered")

func _on_body_entered(_body):
	SoundLibrary.play(SoundLibrary.Sounds.COIN)
	queue_free()
