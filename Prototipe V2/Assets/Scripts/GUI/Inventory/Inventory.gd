extends Control

export(int) var max_slot = 10
onready var slot_item = preload("res://Assets/Scripts/GUI/Inventory/slot.gd")
onready var item = preload("res://Assets/Scripts/GUI/Inventory/item.gd")

var SlotList = Array()

func _ready():
	var slots = get_node("Panel/slotscontainer/slots")
	for i in max_slot:
		var slot = slot_item.new()
		slots.add_child(slot)
	pass # Replace with function body.

func get_FreeSlot():
	for slot in SlotList:
		if !slot.item:
			return slot

func _on_Button_pressed():
	var slot = get_FreeSlot()
	var itemName = UnderGlobalSystem.items[0]
	print(itemName.name)
	pass # Replace with function body.

func _on_Exit_pressed():
	queue_free()
	pass # Replace with function body.
