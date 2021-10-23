extends TextureButton

onready var HoverLabel = $CanvasLayer/HoverLabel
onready var HoverLabelTexture = $CanvasLayer/HoverLabel/Texture
onready var HoverLabelText = $CanvasLayer/HoverLabel/Texture/Label

var c
var t : String
var tex
var tag

var hovering = false

onready var Maze = find_parent("Maze")
onready var MainMenu = find_parent("MainMenu")
var Player
var MainMenuGuy

signal close_menu
signal change_bg_button
signal change_mz_button
signal change_pt_button
signal change_plr_button_c
signal change_plr_button_t

func _process(delta):
	if hovering:
		$CanvasLayer.offset = Vector2(get_global_mouse_position().x, get_global_mouse_position().y)
		
func set_label():
	HoverLabelText.text = tag
	#HoverLabelTexture.rect_size = HoverLabelText.rect_size + Vector2(20, 0)

func _on_ColorOption_pressed():
	
	if not Maze == null: Player = Maze.find_node("Player")
	if not MainMenu == null: 
		for child in MainMenu.get_children():
			if "MainMenuGuy" in child.name:
				MainMenuGuy = child
				break
	
	emit_signal("close_menu")
	HoverLabel.hide()
	
	if t == "background":
		VisualServer.set_default_clear_color(c)
		global.background_color = c
		emit_signal("change_bg_button")
	elif t == "maze":
		# Update maze color dynamically here (global.Maze.update?)
		# Must add options menu during play time first
		global.maze_color = c
		emit_signal("change_mz_button")
		if not Maze == null: Maze.update_tile_color()
	elif t == "particle":
		global.particle_color = c
		emit_signal("change_pt_button")
		if not Player == null: Player.modulate_particles()
		if not MainMenuGuy == null: MainMenuGuy.modulate_particles()
	elif t == "player_color":
		global.player_color = c
		#Default maze guy texture goes here
		global.player_texture = global.default_texture
		emit_signal("change_plr_button_c")
		if not Player == null: Player.modulate_player_color()
		if not MainMenuGuy == null: MainMenuGuy.modulate_color()
	elif t == "player_sprite":
		global.player_color = Color(1, 1, 1, 1)
		global.player_texture = tex
		emit_signal("change_plr_button_t")
		if not Player == null: Player.modulate_player_sprite()
		if not MainMenuGuy == null: MainMenuGuy.modulate_sprite()

func _on_Button_mouse_entered():
	hovering = true
	HoverLabel.show()

func _on_Button_mouse_exited():
	hovering = false
	HoverLabel.hide()
	
