extends KinematicBody2D

var velocity = Vector2.ZERO
var last_dir = -1
var particle_offset = 14
var maze_start_pos = Vector2()
var local_disable_movement
var is_dead = false

onready var Maze = find_parent("Maze")

func _ready():
	randomize()
	local_disable_movement = true

func _physics_process(delta):
	
	# May change this to its own disable movement global
	if global.disable_movement == false and local_disable_movement == false:
		if velocity.normalized() == Vector2.RIGHT:
			position.y = lerp(position.y, stepify(position.y, global.tile_size / 2), 0.2)
		if velocity.normalized() == Vector2.LEFT:
			position.y = lerp(position.y, stepify(position.y, global.tile_size / 2), 0.2)
		if velocity.normalized() == Vector2.DOWN:
			position.x = lerp(position.x, stepify(position.x, global.tile_size / 2), 0.2)
		if velocity.normalized() == Vector2.UP:
			position.x = lerp(position.x, stepify(position.x, global.tile_size / 2), 0.2)
		
		update_particles(velocity.normalized())
		
		if is_dead == false:
			velocity = velocity.normalized() * 100
			velocity =  move_and_slide(velocity)

func initial_movement():
	#print("initial movement")
	var dir
	var fallback
	var dirs = [0, 0, 0, 0]

	if test_move(Transform2D(rotation, position), Vector2.UP * 16): dirs[0] = 1
	if test_move(Transform2D(rotation, position), Vector2.DOWN * 16): dirs[1] = 1
	if test_move(Transform2D(rotation, position), Vector2.RIGHT * 16): dirs[2] = 1
	if test_move(Transform2D(rotation, position), Vector2.LEFT * 16): dirs[3] = 1
	
	if last_dir == 0: 
		dirs[1] = 1
		fallback = 1
	elif last_dir == 1: 
		dirs[0] = 1
		fallback = 0
	elif last_dir == 2: 
		dirs[3] = 1
		fallback = 3
	elif last_dir == 3: 
		dirs[2] = 1
		fallback = 2
	
	if 0 in dirs:
		while true:
			dir = randi() % dirs.size()
			if dirs[dir] == 0:
				break
	else:
		dir = fallback
	last_dir = dir
	
	if dir == 0:
		velocity = Vector2.UP
	elif dir == 1:
		velocity = Vector2.DOWN
	elif dir == 2:
		velocity = Vector2.RIGHT
	elif dir == 3:
		velocity = Vector2.LEFT

func update_particles(v : Vector2):
	$TrailParticles.position = -particle_offset * v
	v.y *= -1
	$TrailParticles.rotation = v.angle_to(Vector2.DOWN)

func explode():
	is_dead = true
	velocity = Vector2.ZERO
	$Sprite.hide()
	$TrailParticles.hide()
	$DeathParticles.emitting = true
	$CollisionShape2D.disabled = true
	yield(get_tree().create_timer(2.0), "timeout")
	queue_free()

#func look_for_wall():
#	if test_move(Transform2D(rotation, position), velocity.normalized() * 16):
#		$MoveTimer.start($MoveTimer.time_left + 0.5)
#		initial_movement()

func _on_MoveTimer_timeout():
	#print("move")
	initial_movement()
