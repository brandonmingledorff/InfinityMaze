extends KinematicBody2D

const N = 1
const E = 2
const S = 3
const W = 4

var rng
var threshold = 200
var speed = 200
var screen_size
var screen_position
var dir = 0
var last_dir = 0
var velocity = 0

func _ready():
	rng = RandomNumberGenerator.new()
	rng.randomize()
	
	if not global.player_color == Color(1, 1, 1, 1):
		modulate_color()
	else:
		modulate_sprite()
	
	modulate_particles()
		
	choose_direction_and_go()

func _process(delta):
	velocity = move_and_slide(velocity)
	#print(str(position))

func choose_direction_and_go():
	screen_size = get_viewport_rect().size
	screen_position = get_viewport_rect().position
	
	while true:
		dir = N + (randi() % (W - N + 1))
		if not dir == last_dir:
			break
	
	last_dir = dir
		
	#print(str(dir))
	
	if dir == N:
		position = Vector2(rng.randf_range(threshold, screen_size.x - threshold), screen_size.y + threshold)
		rotation_degrees = 0
		velocity = Vector2.UP * speed
	elif dir == E:
		position = Vector2(-threshold, rng.randf_range(threshold, screen_size.y - threshold))
		rotation_degrees = 90
		velocity = Vector2.RIGHT * speed
	elif dir == S:
		position = Vector2(rng.randf_range(threshold, screen_size.x - threshold), -threshold)
		rotation_degrees = 180
		velocity = Vector2.DOWN * speed
	elif dir == W:
		position = Vector2(screen_size.x + threshold, rng.randf_range(threshold, screen_size.y - threshold))
		rotation_degrees = -90
		velocity = Vector2.LEFT * speed
	
	#print(str(position))
func modulate_color():
	$Sprite.modulate = global.player_color
	$Sprite.set_texture(load(global.sprite_path + global.default_texture))
		
func modulate_sprite():
	$Sprite.modulate = Color(1, 1, 1, 1)
	$Sprite.set_texture(load(global.sprite_path + global.player_texture))

func modulate_particles():
	$Particles2D.modulate = global.particle_color

func _on_VisibilityNotifier2D_viewport_exited(viewport):
	yield(get_tree().create_timer(2.0), "timeout")
	choose_direction_and_go()
