extends Node
class_name UnderGlobalSystem

enum item_type {
	item_weapon,
	item_potion,
	item_food,
	item_drink,
	item_helmet,
	item_armor,
	item_glove,
	item_boot
}

enum item_rarity {
	NORMAL = 0,
	ELITE,
	RARE,
	LEGENDARY
}

enum inventory_struc {
	item_name,
	item_type,
	item_base_damage,
	item_weight,
	item_rarity,
	item_stat_1,
	item_stat_2,
	item_stat_3,
	item_stat_4,
	item_stat_5,
	item_amount
}

