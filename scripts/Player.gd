extends KinematicBody2D

onready var Bomb = preload("res://scenes/Bomb.tscn")
onready var HUD = find_parent("Maze").find_node("HUD")
onready var Maze = find_parent("Maze")
onready var move_tween = $MovementTween

export var particle_offset = 14
var velocity = Vector2.ZERO

var n = false
var s = false
var e = false
var w = false

func _ready():
	global.disable_movement = false
	modulate_particles()
	
	if not global.player_color == Color(1, 1, 1, 1):
		modulate_player_color()
	else:
		modulate_player_sprite()

func get_input():
	#print(str(position))
	if global.disable_movement == false:
		if Input.is_action_just_pressed('right'):
			velocity = Vector2.RIGHT
			update_particles(velocity)
		if Input.is_action_just_pressed('left'):
			velocity = Vector2.LEFT
			update_particles(velocity)
		if Input.is_action_just_pressed('down'):
			velocity = Vector2.DOWN
			update_particles(velocity)
		if Input.is_action_just_pressed('up'):
			velocity = Vector2.UP
			update_particles(velocity)
			
		if Input.is_action_just_pressed("place_bomb"):
			place_bomb()
		
	if velocity.normalized() == Vector2.RIGHT:
		n = false
		e = true
		s = false
		w = false
		position.y = lerp(position.y, stepify(position.y, global.tile_size / 2), 0.2)
	if velocity.normalized() == Vector2.LEFT:
		n = false
		e = false
		s = false
		w = true
		position.y = lerp(position.y, stepify(position.y, global.tile_size / 2), 0.2)
	if velocity.normalized() == Vector2.DOWN:
		n = false
		e = false
		s = true
		w = false
		position.x = lerp(position.x, stepify(position.x, global.tile_size / 2), 0.2)
	if velocity.normalized() == Vector2.UP:
		n = true
		e = false
		s = false
		w = false
		position.x = lerp(position.x, stepify(position.x, global.tile_size / 2), 0.2)
	
	if global.disable_movement == false:
		velocity = velocity.normalized() * global.player_speed

func _physics_process(delta):
	get_input()
	velocity = move_and_slide(velocity)
	
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.name == "TileMap":
			#print("tilemap")
			if global.inside_sf == false and not global.gamemode == "relaxed":
				global.lives -= 1
				HUD.update_lives()
				
				if global.lives <= 0:
					Maze.game_over()
				else:
					bounce_off_wall()
					
		elif "Enemy" in collision.collider.name:
			if global.inside_sf == false and global.collision_disabled == false:
				global.lives -= 1
				HUD.update_lives()
				
				if global.lives <= 0:
					Maze.game_over()
				else:
					explode()
				
				collision.collider.explode()

func place_bomb():
	var b_pos = Vector2()
	if global.num_bombs > 0:
		global.num_bombs -= 1
		HUD.update_bombs()
		
		var b = Bomb.instance()
		Maze.add_child(b)
		
		b_pos.x = stepify(position.x, global.tile_size)
		b_pos.y = stepify(position.y, global.tile_size)
		b_pos.x = b_pos.x + (global.tile_size / 2) if position.x >= b_pos.x else b_pos.x - (global.tile_size / 2)
		b_pos.y = b_pos.y + (global.tile_size / 2) if position.y >= b_pos.y else b_pos.y - (global.tile_size / 2)
		
		b.position = b_pos
	
func blink():
	$Sprite.modulate.a = 0.5
	yield(get_tree().create_timer(0.15), "timeout")
	$Sprite.modulate.a = 1.0
	yield(get_tree().create_timer(0.15), "timeout")
	$Sprite.modulate.a = 0.5
	yield(get_tree().create_timer(0.15), "timeout")
	$Sprite.modulate.a = 1.0

func update_particles(v : Vector2):
	$TrailParticles.position = -particle_offset * v
	v.y *= -1
	$TrailParticles.rotation = v.angle_to(Vector2.DOWN)

func modulate_particles():
	$TrailParticles.modulate = global.particle_color
	
func modulate_player_color():
	$Sprite.modulate = global.player_color
	$Sprite.set_texture(load(global.sprite_path + global.default_texture))
		
func modulate_player_sprite():
	$Sprite.modulate = Color(1, 1, 1, 1)
	$Sprite.set_texture(load(global.sprite_path + global.player_texture))

func bounce_off_wall():
	global.disable_movement = true
	global.collision_disabled = true
	
	var newpos_x = stepify(position.x, global.tile_size / 2)
	var newpos_y = stepify(position.y, global.tile_size / 2)
	
	if n:
		if newpos_y < position.y: newpos_y += (global.tile_size / 2)
	if s:
		if newpos_y > position.y: newpos_y -= (global.tile_size / 2)
	if e:
		if newpos_x > position.x: newpos_x -= (global.tile_size / 2)
	if w:
		if newpos_x < position.x: newpos_x += (global.tile_size / 2)
		
	move_tween.interpolate_property(self, "position", position, 
	Vector2(newpos_x, newpos_y), 0.2, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	move_tween.start()
	
	blink()
	
	yield(get_tree().create_timer(1.0), "timeout")
	global.disable_movement = false
	global.collision_disabled = false
	initial_movement()
	
func explode():
	global.disable_movement = true
	
	$Sprite.hide()
	$TrailParticles.hide()
	
	$DeathParticles.emitting = true
	$CollisionShape2D.disabled = true
	
	yield(get_tree().create_timer(2.0), "timeout")
	
	$Sprite.show()
	$TrailParticles.rotation = deg2rad(0)
	$TrailParticles.position = Vector2(0, particle_offset)
	$TrailParticles.show()
	
	global.disable_movement = false
	$CollisionShape2D.disabled = false
	
	if global.lives > 0: 
		Maze.respawn() 
	else: 
		queue_free()

func initial_movement():
	#print("initial movement")
	
	var north = false
	var south = false
	var east = false
	var west = false

	if Input.is_action_pressed('right'):
		velocity = Vector2.RIGHT
	elif Input.is_action_pressed('left'):
		velocity = Vector2.LEFT
	elif Input.is_action_pressed('down'):
		velocity = Vector2.DOWN
	elif Input.is_action_pressed('up'):
		velocity = Vector2.UP
	else:
		if test_move(Transform2D(rotation, position), Vector2.UP * 20):
			#print("n")
			north = true
		if test_move(Transform2D(rotation, position), Vector2.DOWN * 20):
			#print("s")
			south = true
		if test_move(Transform2D(rotation, position), Vector2.RIGHT * 20):
			#print("e")
			east = true
		if test_move(Transform2D(rotation, position), Vector2.LEFT * 20):
			#print("w")
			west = true
			
		if north == false:
			velocity = Vector2.UP
		elif east == false:
			velocity = Vector2.RIGHT
		elif west == false:
			velocity = Vector2.LEFT
		elif south == false:
			velocity = Vector2.DOWN
	update_particles(velocity)

func next_stage():
	#("next_stage")
	$TrailParticles.rotation = deg2rad(0)
	$TrailParticles.position = Vector2(0, particle_offset)
