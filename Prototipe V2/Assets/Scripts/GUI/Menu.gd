extends Control

onready var inventory_scn = preload("res://Assets/Scenes/GUI/Inventory/Inventory.tscn")

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	pass # Replace with function body.

func _on_Resume_btn_pressed():
	get_tree().paused = false
	queue_free()
	pass # Replace with function body.


func _on_Exit_pressed():
	get_tree().quit()
	pass # Replace with function body.


func _on_Inventory_pressed():
	var inventory = inventory_scn.instance()
	add_child(inventory)
	pass # Replace with function body.
