extends Node2D


class BreakpointSorter:
	static func sort(a, b): return a.global_position < b.global_position


func _ready():
	for level in get_tree().get_nodes_in_group("level"):
		level.free()
	
	var level = GameData.level.instance()
	level.add_to_group("level")
	get_tree().current_scene.add_child(level)
	
	var bps = get_tree().get_nodes_in_group(GameData.spawn_point)
	var bp = bps[0]
	bps.sort_custom(BreakpointSorter, "sort")
	bps.invert()

	for breakp in bps:
		if breakp.global_position <= Mario.global_position:
			bp = breakp
			break

	Mario.global_position = bp.global_position
	var camera = Mario.get_node("Camera2D")
	camera.limit_left = Mario.position.x-56
	if camera.limit_left < 0: camera.limit_left = 0
	camera.limit_right = int(level.get_meta("width")*16)

	Mario.velocity.y = 0
	if GameData.spawn_point == 'pipe_exit':
		Mario.rise()
	else:
		Mario.movable = true
	
	SoundLibrary.stop_all()
	if level.get_meta("underworld"):
		SoundLibrary.play(SoundLibrary.Sounds.UNDERWORLD)
	else:
		SoundLibrary.play(SoundLibrary.Sounds.MAIN_THEME)
