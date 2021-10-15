extends Node

const items_dictonary_file_path = "res://Assets/Datas/itemsDictonary.dic"
var config = ConfigFile.new()

var config_itemsDictonary = config.load(items_dictonary_file_path)

var items = {
	0:{
		"name" : "Steel Dagger",
		"type" : "weapon",
		"weight" : 5,
		"base_damage" : 5, 
		"img" : preload("res://Assets/Imgs/Items/slice12.png")
	},
	1:{
		"name" : "Revolver",
		"type" : "weapon",
		"weight" : 3,
		"base_damage" : 10,
		"img" : preload("res://Assets/Imgs/Items/slice13.png")
	},
	2:{
		"name" : "Steel Sword",
		"type" : "weapon",
		"weight" : 10,
		"base_damage" : 20,
		"img" : preload("res://Assets/Imgs/Items/slice13.png")
	}
}

func _ready():
	write_data()
	pass

func write_data():
	for insert_data in items.size():
		var item = items[insert_data]
		config.set_value("id_" + String(insert_data),"name",item.name)
		config.set_value("id_" + String(insert_data),"type",item.type)
		config.set_value("id_" + String(insert_data),"weight",item.weight)
		config.set_value("id_" + String(insert_data),"base_damage",item.base_damage)
		config.set_value("id_" + String(insert_data),"img",item.img)
		config.save(items_dictonary_file_path)
	pass

func read_data():
	
	pass
	
