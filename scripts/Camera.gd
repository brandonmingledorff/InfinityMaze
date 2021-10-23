extends Camera2D

const ZOOM_FACTOR = 1.2

var screen_size
var bounce_intensity = 0.004
onready var move_tween = $MovementTween
onready var zoom_tween = $ZoomTween
onready var bounce_tween = $BounceTween

func _ready():
	screen_size = get_viewport_rect()
	#bounce()

func bounce():
	var original_zoom = zoom
	var new_zoom = zoom + Vector2(bounce_intensity, bounce_intensity)
	bounce_tween.interpolate_property(self, "zoom",
		original_zoom, new_zoom, 0.5,
		Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	bounce_tween.start()

func move_camera(coords, width, height):
	var f_width : float = width
	var f_height : float = height
	screen_size = get_viewport_rect()
	bounce_tween.set_active(false)
	
	var newpos_x = (coords.x + (f_width / 2)) * global.tile_size
	var newpos_y = (coords.y + (f_height / 2)) * global.tile_size
	var newzoom = (global.tile_size * height / screen_size.size.y) * ZOOM_FACTOR
	
	move_tween.interpolate_property(self, "position",
		position, Vector2(newpos_x, newpos_y), 1.3,
		Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	zoom_tween.interpolate_property(self, "zoom",
		zoom, Vector2(newzoom, newzoom), 1.3,
		Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	move_tween.start()
	zoom_tween.start()
	
	#yield(zoom_tween, "tween_completed")
	#bounce()
	
func level_end_camera():
	var seconds : float = (abs(position.y)) / 10.0
	bounce_tween.set_active(false)
	
	move_tween.interpolate_property(self, "position",
		position, Vector2(position.x, 100), seconds,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	zoom_tween.interpolate_property(self, "zoom",
		zoom, zoom * 4, 6.0,
		Tween.TRANS_LINEAR, Tween.EASE_OUT_IN)
	move_tween.start()
	zoom_tween.start()
