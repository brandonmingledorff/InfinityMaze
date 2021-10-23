extends Control

onready var MainMenu = find_parent("MainMenu")
onready var ShopButton = $Button
onready var PriceLabel = $Label
onready var HoverLabel = $CanvasLayer/HoverLabel
onready var HoverLabelTexture = $CanvasLayer/HoverLabel/Texture
onready var HoverLabelText = $CanvasLayer/HoverLabel/Texture/Label

var OptionsMenu

var hovering = false

var PLR_Select
var PT_Select
var BG_Select
var MZ_Select

var PLR_Grid
var PT_Grid
var BG_Grid
var MZ_Grid

var price
var display_price : float
var type
var color
var texture
var tag

func _ready():
	if not MainMenu == null: 
		#OptionsMenu = MainMenu.find_node("OptionsMenu")
		for child in MainMenu.get_children():
			if "OptionsMenu" in child.name:
				OptionsMenu = child
				break
	
	if not OptionsMenu == null:
		PLR_Select = OptionsMenu.find_node("PlayerSpriteSelect")
		PT_Select = OptionsMenu.find_node("ParticleColorSelect")
		BG_Select = OptionsMenu.find_node("BackgroundSelect")
		MZ_Select = OptionsMenu.find_node("MazeColorSelect")

func _process(delta):
	if hovering:
		$CanvasLayer.offset = Vector2(get_global_mouse_position().x, get_global_mouse_position().y)
		
func setup():
	# Disable button if too expensive
	if price > global.coins:
		ShopButton.disabled = true
		ShopButton.modulate.a = 0.35
		
	# Cast price to a float so that display price can show decimals
	display_price = price
	
	# Make the price that is displayed readable and not 7 digits long
	# i.e. 1,200,000 coins -> 1.2M
	# i.e. 2,400 coins -> 2.4K
	if price >= 1000 and price < 100000:
		display_price = display_price / 1000
		PriceLabel.text = str(stepify(display_price, 0.1)) + "K"
	elif price >= 100000 and price < 1000000:
		display_price = display_price / 1000
		PriceLabel.text = str(stepify(display_price, 1)) + "K"
	elif price > 1000000:
		display_price = display_price / 1000000
		PriceLabel.text = str(stepify(display_price, 0.1)) + "M"
	else:
		PriceLabel.text = str(price)

func set_label():
	HoverLabelText.text = tag
	#HoverLabelTexture.rect_size = HoverLabelText.rect_size + Vector2(20, 0)

func _on_Button_pressed():
	global.coins -= price
	find_parent("ShopMenu").update_balance()
	
	if type == "color":
		global.available_colors[color] = tag
		
		PLR_Select.setup_all()
		PT_Select.setup_colors()
		BG_Select.setup_colors()
		MZ_Select.setup_colors()

	elif type == "texture":
		global.available_player_sprites[texture] = tag
		
		PLR_Select.setup_all()
	
	# Go through children in shop menu grids and disable options that are too expensive
	var color_children = find_parent("ShopMenu").find_node("ColorGrid").get_children()
	for child in color_children:
		child.setup()
	
	var sprite_children = find_parent("ShopMenu").find_node("SpriteGrid").get_children()
	for child in sprite_children:
		child.setup()
	
	queue_free()

func _on_Button_mouse_entered():
	hovering = true
	HoverLabel.show()

func _on_Button_mouse_exited():
	hovering = false
	HoverLabel.hide()
