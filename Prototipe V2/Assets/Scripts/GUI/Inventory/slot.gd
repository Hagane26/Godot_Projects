extends Panel

var default_tex = preload("res://Assets/Imgs/GUI/Inventory/slot.png")

var default_style : StyleBoxTexture = null
var textb : Label

# Called when the node enters the scene tree for the first time.
func _init():
	rect_min_size = Vector2(58,58)
	default_style = StyleBoxTexture.new()
	default_style.texture = default_tex
	set('custom_styles/panel',default_style)
	pass # Replace with function body.

func set_item(new_item):
	add_child(new_item)
	textb = Label.new()
	textb.text = "0"
	set("custom_fonts/font",load("res://Assets/Font/Frisky Puppy.otf"))
	add_child(textb)
	pass
