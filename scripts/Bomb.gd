extends Area2D

const N = 1
const E = 2
const S = 4
const W = 8

var Maze
var Map

var dir_loop_array = [~(S | E), ~(S | E | W), ~(W | S), 
~(N | S | E), ~(N | S | W), ~(N | E), ~(W | N | E), ~(W | N)]

func _ready():
	Maze = find_parent("Maze")
	if not Maze == null: Map = Maze.find_node("TileMap")

func _process(delta):
	$Label.text = str(stepify($Timer.time_left, 0.1))

func blow_up():
	var cell_pos
	var cell_id
	
	$Sprite.hide()
	$Label.hide()
	$Particles2D.emitting = true
	
	var enemies = get_tree().get_nodes_in_group("enemies")
	var new_tl = Maze.coords * global.tile_size
	var new_size = Vector2(Maze.curr_maze_width, Maze.curr_maze_height) * global.tile_size
	
	for enemy in enemies:
		if Rect2(new_tl, new_size).has_point(enemy.position):
			if position.distance_to(enemy.position) < $CollisionShape2D.shape.radius * 2:
				enemy.explode()
	
	var bomb_pos = Map.world_to_map(position)
	Map.set_cellv(bomb_pos, 16)
	
	if bomb_pos.x == Maze.coords.x:
		Map.set_cellv(bomb_pos, (Map.get_cellv(bomb_pos) | W) % 16 + 16)
	if bomb_pos.x == Maze.coords.x + Maze.curr_maze_width - 1:
		Map.set_cellv(bomb_pos, (Map.get_cellv(bomb_pos) | E) % 16 + 16)
	if bomb_pos.y == Maze.coords.y:
		Map.set_cellv(bomb_pos, (Map.get_cellv(bomb_pos) | N) % 16 + 16)
	if bomb_pos.y == Maze.coords.y + Maze.curr_maze_height - 1:
		Map.set_cellv(bomb_pos, (Map.get_cellv(bomb_pos) | S) % 16 + 16)
	
	var idx = 0
	for y in [-1, 0, 1]:
		for x in [-1, 0, 1]:
			cell_pos = Vector2(bomb_pos.x + x, bomb_pos.y + y)
			cell_id = Map.get_cellv(cell_pos)
			if not cell_pos.y < Maze.coords.y and not cell_pos.y > Maze.coords.y + Maze.curr_maze_height - 1:
				if not cell_pos == bomb_pos:
					if not cell_id == -1 and not cell_id == 16:
						Map.set_cellv(cell_pos, (cell_id & dir_loop_array[idx]) % 16 + 16)
						
						#print(str((cell_id & dir_loop_array[idx]) % 16 + 16))
						
						if cell_pos.x == Maze.coords.x:
							Map.set_cellv(cell_pos, (Map.get_cellv(cell_pos) | W) % 16 + 16)
						if cell_pos.x == Maze.coords.x + Maze.curr_maze_width - 1:
							Map.set_cellv(cell_pos, (Map.get_cellv(cell_pos) | E) % 16 + 16)
						if cell_pos.y == Maze.coords.y:
							Map.set_cellv(cell_pos, (Map.get_cellv(cell_pos) | N) % 16 + 16)
						if cell_pos.y == Maze.coords.y + Maze.curr_maze_height - 1:
							Map.set_cellv(cell_pos, (Map.get_cellv(cell_pos) | S) % 16 + 16)
						
					idx += 1
	
	Maze.update_tile_color()
	Map.update_dirty_quadrants()

	yield(get_tree().create_timer(2.0), "timeout")
	queue_free()

func _on_Timer_timeout():
	blow_up()

