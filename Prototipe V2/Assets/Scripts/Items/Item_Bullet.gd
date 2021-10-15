extends Area2D

export var item_type = "Weapon"
export var item_name = "Bullet"
export var item_count = 5

func taked():
	queue_free()
