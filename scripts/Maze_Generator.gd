extends Node

const N = 1
const E = 2
const S = 4
const W = 8

var cell_walls = {Vector2(1, 0): E, Vector2(-1, 0): W, Vector2(0, 1): S, Vector2(0, -1): N}

func make_maze(x_start, y_start, width, height, Map):
	var unvisited = []
	var stack = []
	
	for x in range(x_start, width + x_start):
		for y in range(y_start, height + y_start):
			unvisited.append(Vector2(x, y))
			Map.set_cellv(Vector2(x, y), N|E|S|W)
	var current = Vector2(x_start, y_start)
	unvisited.erase(current)
	
	while unvisited:
		var neighbors = check_neighbors(current, unvisited)
		if neighbors.size() > 0:
			var next = neighbors[randi() % neighbors.size()]
			stack.append(current)
			
			var dir = next - current
			var current_walls = Map.get_cellv(current) - cell_walls[dir]
			var next_walls = Map.get_cellv(next) - cell_walls[-dir]
			
			Map.set_cellv(current, current_walls)
			Map.set_cellv(next, next_walls)
			current = next
			unvisited.erase(current)
		elif stack:
			current = stack.pop_back()

func check_neighbors(cell, unvisited):
	var list = []
	
	for n in cell_walls.keys():
		if cell + n in unvisited:
			list.append(cell + n)
	return list
