extends Node2D

var t = 0

func _physics_process(delta):
	t += delta*1.5
	var pos = $Path2D.curve.interpolate_baked(t * $Path2D.curve.get_baked_length())
	$SpriteTopRight.position = Vector2(pos.x, pos.y)
	$SpriteBottomRight.position = Vector2(pos.x, pos.y)
	$SpriteTopLeft.position = Vector2(-pos.x, pos.y)
	$SpriteBottomLeft.position = Vector2(-pos.x, pos.y)
	$SpriteTopRight.rotation = t
	$SpriteBottomRight.rotation = t*3
	$SpriteTopLeft.rotation = t
	$SpriteBottomLeft.rotation = -t*3
	if t >= 1:
		queue_free()
