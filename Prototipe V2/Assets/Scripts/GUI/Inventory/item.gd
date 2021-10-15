extends TextureRect

var item1 = preload("res://Assets/Imgs/Items/slice1.png")

# Called when the node enters the scene tree for the first time.
func _init():
	expand = true
	rect_min_size = Vector2(50,50)
	texture = item1
	set_size(Vector2(0,0))
	margin_left = 5
	margin_right = -5
	margin_top = 5
	margin_bottom = -5
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
