extends ParallaxBackground

const _w = 465

func _ready():
	$ParallaxLayer/TextureRect.rect_size.x *= 2

func _process(delta):
	scroll_offset.x = wrapf(scroll_offset.x - 40 * delta, -_w, 0)
