extends Node


class Item:
	var x
	var y
	var color
	var block
	func _init(vx, vy, vcolor):
		x = vx
		y = vy
		color = vcolor


export(int) var ROWS = 8
export(int) var COLS = 8

var table = []


func _ready():
	randomize()
	new_game()


func new_game():
	table = generate()


func generate():
	var t

	while true:
		t = []

		for j in ROWS:
			var row = []
			for i in COLS:
				row.append(null)
			t.append(row)

		for j in ROWS:
			for i in COLS:
				var color
				while true:
					color = randi() % 6
					var v1 = t[j][i-2].color if i-2 >= 0 and t[j][i-2] else null
					var v2 = t[j][i+2].color if i+2 < COLS and t[j][i+2] else null
					var v3 = t[j-2][i].color if j-2 >= 0 and t[j-2][i] else null
					var v4 = t[j+2][i].color if j+2 < ROWS and t[j+2][i] else null
					if color != v1 and color != v2 and color != v3 and color != v4:
						break
				t[j][i] = Item.new(i, j, color)

		if validate(t):
			break

	return t


func validate(t = table):
	var clone = t.duplicate(true)
	for j in ROWS:
		for i in COLS:
			var v1 = clone[j][i]
			var v2 = clone[j][i+1] if i+1 < COLS else null
			if v2 != null:
				clone[j][i] = v2
				clone[j][i+1] = v1
				if matches(clone).size() > 0:
					return true
				clone[j][i] = v1
				clone[j][i+1] = v2
			v2 = clone[j+1][i] if j+1 < ROWS else null
			if v2 != null:
				clone[j][i] = v2
				clone[j+1][i] = v1
				if matches(clone).size() > 0:
					return true
				clone[j][i] = v1
				clone[j+1][i] = v2
	return false


func matches(t = table):
	var ret = []
	
	for y in ROWS:
		var acc = 1
		var pv = null
		for x in COLS+1:
			var v = t[y][x].color if x < COLS and y < ROWS else null
			if v == pv:
				acc += 1
			else:
				if acc >= 3:
					ret.append([Vector2(x-acc, y), Vector2(x-1, y)])
				acc = 1
				pv = v
	
	for x in COLS:
		var acc = 1
		var pv = null
		for y in ROWS+1:
			var v = t[y][x].color if x < COLS and y < ROWS else null
			if v == pv:
				acc += 1
			else:
				if acc >= 3:
					ret.append([Vector2(x, y-acc), Vector2(x, y-1)])
				acc = 1
				pv = v
	
	return ret


func fill(t = table):
	for y in ROWS:
		for x in COLS:
			if t[y][x].color == null:
				for i in range(y, 0, -1):
					move(Vector2(x, i), Vector2(x, i-1), t)

	var ret = []
	var nt = generate()
	for y in ROWS:
		for x in COLS:
			if t[y][x].color == null:
				var item = Item.new(x, y, nt[y][x].color)
				t[y][x] = item
				ret.append(item)
	return ret


func move(p1, p2, t = table):
	var v1 = t[p1.y][p1.x]
	var v2 = t[p2.y][p2.x]
	t[p1.y][p1.x] = v2
	t[p2.y][p2.x] = v1
	var vx = v1.x
	var vy = v1.y
	v1.x = v2.x
	v1.y = v2.y
	v2.x = vx
	v2.y = vy
	if v1.block:
		v1.block.grid_position = Vector2(v1.x, v1.y)
	if v2.block:
		v2.block.grid_position = Vector2(v2.x, v2.y)


func swap(p1, p2, t = table):
	var v1 = t[p1.y][p1.x]
	var v2 = t[p2.y][p2.x]
	t[p1.y][p1.x] = v2
	t[p2.y][p2.x] = v1
	var m = matches()
	t[p1.y][p1.x] = v1
	t[p2.y][p2.x] = v2

	if m.size() > 0:
		move(p1, p2, t)
		return m
	else:
		return null
