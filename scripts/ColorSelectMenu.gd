extends Control

onready var ColorOption = preload("res://scenes/ColorOption.tscn")

var t : String

onready var Grid = $Texture/ScrollContainer/GridContainer

var PLR_BUTTON
var PT_BUTTON
var MZ_BUTTON
var BG_BUTTON

func _ready():
	PLR_BUTTON = get_parent().find_node("PlayerSpriteButton")
	PT_BUTTON = get_parent().find_node("ParticleColorButton")
	BG_BUTTON = get_parent().find_node("BackgroundColorButton")
	MZ_BUTTON = get_parent().find_node("MazeColorButton")
	
	PT_BUTTON.modulate = global.particle_color
	BG_BUTTON.modulate = global.background_color
	MZ_BUTTON.modulate = global.maze_color
	
	if not global.player_color == Color(1, 1, 1, 1):
		PLR_BUTTON.modulate = global.player_color
		PLR_BUTTON.set_normal_texture(load(global.sprite_path + global.default_button_texture))
	else:
		PLR_BUTTON.modulate = Color(1, 1, 1, 1)
		if global.player_texture == global.default_texture:
			PLR_BUTTON.set_normal_texture(load(global.sprite_path + global.default_button_texture))
		else:
			PLR_BUTTON.set_normal_texture(load(global.sprite_path + global.player_texture))

func add_color(color, tag):
	var c = ColorOption.instance()
	Grid.add_child(c)
	c.connect("close_menu", self, "hide")
	c.t = "player_color" if t == "player" else t
	c.tag = tag
	c.set_label()
	c.self_modulate = color
	c.c = color
	
	if t == "background":
		c.connect("change_bg_button", self, "update_bg_button")
	elif t == "maze":
		c.connect("change_mz_button", self, "update_mz_button")
	elif t == "particle":
		c.connect("change_pt_button", self, "update_pt_button")
	elif t == "player":
		c.connect("change_plr_button_c", self, "update_plr_button_c")
		
func add_texture(texture, tag):
	var c = ColorOption.instance()
	Grid.add_child(c)
	c.connect("close_menu", self, "hide")
	c.t = "player_sprite" if t == "player" else t
	c.tag = tag
	c.set_label()
	c.set_normal_texture(load(global.sprite_path + texture))
	c.tex = texture
	
	if t == "background":
		c.connect("change_bg_button", self, "update_bg_button")
	elif t == "maze":
		c.connect("change_mz_button", self, "update_mz_button")
	elif t == "particle":
		c.connect("change_pt_button", self, "update_pt_button")
	elif t == "player":
		c.connect("change_plr_button_t", self, "update_plr_button_t")

func setup_all():
	setup_colors()
	setup_textures()
	
func setup_colors():
	
	var children = Grid.get_children()
	for child in children:
		if not child.t == "player_sprite":
			child.queue_free()
	
	for color in global.available_colors:
		add_color(color, global.available_colors[color])

func setup_textures():
	
	var children = Grid.get_children()
	for child in children:
		if child.t == "player_sprite":
			child.queue_free()
	
	for sprite in global.available_player_sprites:
		add_texture(sprite, global.available_player_sprites[sprite])
		
func update_pt_button():
	PT_BUTTON.modulate = global.particle_color

func update_bg_button():
	BG_BUTTON.modulate = global.background_color
	
func update_mz_button():
	MZ_BUTTON.modulate = global.maze_color

func update_plr_button_c():
	#print("update plr button c")
	PLR_BUTTON.modulate = global.player_color
	PLR_BUTTON.set_normal_texture(load(global.sprite_path + global.default_button_texture))
	
func update_plr_button_t():
	#print("update plr button t")
	PLR_BUTTON.modulate = Color(1, 1, 1, 1)
	PLR_BUTTON.set_normal_texture(load(global.sprite_path + global.player_texture))

