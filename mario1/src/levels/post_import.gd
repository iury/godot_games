extends Node

const BlockTypes = preload("res://src/sprites/Block.gd").BlockTypes

func post_import(scene):
	var Block = load("res://src/sprites/Block.tscn")
	var Brick = load("res://src/sprites/Brick.tscn")
	var Goomba = load("res://src/sprites/Goomba.tscn")
	var Koopa = load("res://src/sprites/Koopa.tscn")
	var PipeEntry = load("res://src/sprites/PipeEntry.tscn")
	var Coin = load("res://src/sprites/Coin.tscn")
	var Flag = load("res://src/sprites/Flag.tscn")
	var CastleFlag = load("res://src/sprites/CastleFlag.tscn")
	
	scene.position = Vector2(0, 16)

	for node in scene.get_children():
		if node is TileMap:
			if node.has_meta('z_index'):
				node.z_index = node.get_meta('z_index')

		elif node is Node2D:
			for obj in node.get_children():
				if obj.has_meta('name'):
					var new_node

					match obj.get_meta('name'):
						'breakpoint':
							new_node = Position2D.new()
							new_node.add_to_group("breakpoints", true)

						'pipe_exit':
							new_node = Position2D.new()
							new_node.add_to_group("pipe_exit", true)

						'block':
							new_node = Block.instance()
							new_node.type = BlockTypes.NORMAL

						'powerup_block':
							new_node = Block.instance()
							new_node.type = BlockTypes.POWERUP

						'life_block':
							new_node = Block.instance()
							new_node.type = BlockTypes.LIFE

						'brick':
							new_node = Brick.instance()
						
						'goomba':
							new_node = Goomba.instance()
						
						'koopa':
							new_node = Koopa.instance()

						'pipe_entry':
							new_node = PipeEntry.instance()
							new_node.level = obj.get_meta('level')
							new_node.direction = obj.get_meta('direction')
							new_node.spawn_point = obj.get_meta('spawn_point')

						'coin':
							new_node = Coin.instance()

						'flag':
							new_node = Flag.instance()

						'castle_flag':
							new_node = CastleFlag.instance()

						_:
							print(obj.get_meta('name'))

					if new_node:
						if obj.has_meta('modulate'):
							new_node.modulate = obj.get_meta('modulate')
						
						new_node.position = obj.position + Vector2(8, -32 if obj.has_meta("large") else -24)
						scene.add_child(new_node)
						new_node.set_owner(scene)

			node.free()
	return scene
