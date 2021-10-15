extends Control

signal player_die(stat)
signal player_empty_stamina(stat)

export(int) var max_hp
export(int) var current_hp
export(int) var max_stamina
export(int) var current_stamina

onready var health_bar = $HBC/VBC/healthBar
onready var animated_hp = $HBC/VBC/healthBar/Tween
onready var stamina_bar = $HBC/VBC/StaminaBar
onready var animated_stamina = $HBC/VBC/StaminaBar/Tween

onready var Bullet_count = $bot_HBC/Label
onready var btn_take = $btn_take

onready var MenuS = preload("res://Assets/Scenes/GUI/Menus/Menu.tscn")

func _ready():
	pass # Replace with function body.

func _on_player_set_max_hp(max_hp_player):
	max_hp = max_hp_player
	health_bar.max_value = max_hp
	pass # Replace with function body.

func _on_player_update_hp(player_hp):
	current_hp = player_hp
	animated_hp.interpolate_property(health_bar,"value",health_bar.value,current_hp,0.4,Tween.TRANS_SINE,Tween.EASE_IN_OUT)
	animated_hp.start()
	
	if current_hp <= 0:
		emit_signal("player_die","die")
	
	pass # Replace with function body.

func _on_player_set_max_stamina(max_stamina_player):
	max_stamina = max_stamina_player
	stamina_bar.max_value = max_stamina
	pass # Replace with function body.


func _on_player_update_stamina(player_stamina):
	var style_new = stamina_bar.get("custom_styles/fg")
	current_stamina = player_stamina
	animated_stamina.interpolate_property(stamina_bar,"value",stamina_bar.value,current_stamina,0.8,Tween.TRANS_SINE,Tween.EASE_IN_OUT)
	animated_stamina.start()
	
	if current_stamina <= 0:
		emit_signal("player_empty_stamina",true)
	elif current_stamina >= 1:
		emit_signal("player_empty_stamina",false)
	
	pass # Replace with function body.

func _on_player_update_bullet(player_bullet):
	Bullet_count.text = String(player_bullet)
	pass # Replace with function body.


func _on_Menu_btn_pressed():
	get_tree().paused = true
	var show_menus = MenuS.instance()
	get_node(".").add_child(show_menus)
	pass # Replace with function body.

func _on_player_item_take(stat):
	if stat == true:
		btn_take.visible = true
	else:
		btn_take.visible = false
	pass # Replace with function body.
