extends Control

onready var ShopOption = preload("res://scenes/ShopOption.tscn")
onready var MainMenu = find_parent("MainMenu")
onready var ColorGrid = $Texture/ColorScroller/ColorGrid
onready var SpriteGrid = $Texture/SpriteScroller/SpriteGrid
onready var Balance = $Texture/BalanceLabel

var OptionsMenu
var PLR_Select
var PT_Select
var BG_Select
var MZ_Select

func _ready():
	if not MainMenu == null: 
		for child in MainMenu.get_children():
			if "OptionsMenu" in child.name:
				OptionsMenu = child
				break
	
	if not OptionsMenu == null:
		PLR_Select = OptionsMenu.find_node("PlayerSpriteSelect")
		PT_Select = OptionsMenu.find_node("ParticleColorSelect")
		BG_Select = OptionsMenu.find_node("BackgroundSelect")
		MZ_Select = OptionsMenu.find_node("MazeColorSelect")
	
	update_shop_colors()
	update_shop_sprites()
	update_balance()

func update_shop_colors():
	var children = ColorGrid.get_children()
	
	for child in children:
		child.queue_free()
		
	for entry in global.shop_colors:
		if not entry in global.available_colors:
			var s = ShopOption.instance()
			ColorGrid.add_child(s)
			
			s.type = "color"
			s.tag = global.shop_colors[entry][0]
			s.set_label()
			s.color = entry
			s.price = global.shop_colors[entry][1]
			s.find_node("Button").modulate = entry
			s.setup()
		else:
			if not global.shop_colors[entry][0] == global.available_colors[entry]:
				global.available_colors[entry] = global.shop_colors[entry][0]
				PLR_Select.setup_colors()
				PT_Select.setup_colors()
				BG_Select.setup_colors()
				MZ_Select.setup_colors()
						
func update_shop_sprites():
	var children = SpriteGrid.get_children()
	
	for child in children:
		child.queue_free()
		
	for entry in global.shop_sprites:
		if not entry in global.available_player_sprites:
			var s = ShopOption.instance()
			SpriteGrid.add_child(s)
			
			s.type = "texture"
			s.tag = global.shop_sprites[entry][0]
			s.set_label()
			s.texture = entry
			s.price = global.shop_sprites[entry][1]
			s.find_node("Button").set_normal_texture(load(global.sprite_path + entry))
			s.find_node("Button").rect_size = s.find_node("Button").rect_min_size
			s.setup()
		else:
			if not global.shop_sprites[entry][0] == global.available_player_sprites[entry]:
				global.available_player_sprites[entry] = global.shop_sprites[entry][0]
				PLR_Select.setup_textures()
		
func update_balance():
	Balance.text = str(global.coins)

func _on_CloseButton_pressed():
	hide()
