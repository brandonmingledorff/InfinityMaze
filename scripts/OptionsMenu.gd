extends Control

onready var PLR_BUTTON = $Texture/PlayerSpriteButton
onready var BG_BUTTON = $Texture/BackgroundColorButton
onready var MZ_BUTTON = $Texture/MazeColorButton
onready var PT_BUTTON = $Texture/ParticleColorButton

func _ready():
	$PlayerSpriteSelect.t = "player"
	$BackgroundSelect.t = "background"
	$MazeColorSelect.t = "maze"
	$ParticleColorSelect.t = "particle"
	
	$PlayerSpriteSelect.setup_all()
	$BackgroundSelect.setup_colors()
	$MazeColorSelect.setup_colors()
	$ParticleColorSelect.setup_colors()
	
	if global.player_texture == global.default_texture:
		PLR_BUTTON.modulate = global.player_color
	else:
		PLR_BUTTON.modulate = Color(1, 1, 1, 1)
		PLR_BUTTON.set_normal_texture(load(global.sprite_path + global.player_texture))
		#PLR_BUTTON.set_pressed_texture(load(global.sprite_path + global.player_texture))

	BG_BUTTON.modulate = global.background_color
	MZ_BUTTON.modulate = global.maze_color
	PT_BUTTON.modulate = global.particle_color

func _on_CloseButton_pressed():
	$BackgroundSelect.hide()
	$MazeColorSelect.hide()
	$ParticleColorSelect.hide()
	$PlayerSpriteSelect.hide()
	hide()

# BUG: When in fullscreen, clicking the button to open other select menus while one is open doesn't work
# Works in non-fullscreen
func _on_BackgroundColorButton_pressed():
	#print("bg pressed")
	if $BackgroundSelect.visible == true:
		$BackgroundSelect.hide()
	else:
		$BackgroundSelect.show()
		$PlayerSpriteSelect.hide()
		$MazeColorSelect.hide()
		$ParticleColorSelect.hide()

func _on_MazeColorButton_pressed():
	if $MazeColorSelect.visible == true:
		$MazeColorSelect.hide()
	else:
		$MazeColorSelect.show()
		$PlayerSpriteSelect.hide()
		$BackgroundSelect.hide()
		$ParticleColorSelect.hide()

func _on_ParticleColorButton_pressed():
	if $ParticleColorSelect.visible == true:
		$ParticleColorSelect.hide()
	else:
		$ParticleColorSelect.show()
		$PlayerSpriteSelect.hide()
		$BackgroundSelect.hide()
		$MazeColorSelect.hide()

func _on_PlayerSpriteButton_pressed():
	if $PlayerSpriteSelect.visible == true:
		$PlayerSpriteSelect.hide()
	else:
		$PlayerSpriteSelect.show()
		$ParticleColorSelect.hide()
		$BackgroundSelect.hide()
		$MazeColorSelect.hide()
