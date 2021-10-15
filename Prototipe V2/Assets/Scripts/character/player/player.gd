extends KinematicBody2D

# --------------------------- animated sprite ---------------------------
onready var AS = $AnimatedSprite
onready var atk_area_melee_R = $atk_melee_area_R/CollisionShape2D
onready var atk_area_melee_L = $atk_melee_area_L/CollisionShape2D

# --------------------------- move vector ---------------------------
const up = Vector2(0,-1)
var motion = Vector2()

# --------------------------- Caller another scene ---------------------------
onready var Bullet_Scene = preload("res://Assets/Scenes/Support/Obj/Bullet.tscn")


#--------------------------- player status ---------------------------

#-> Player Base Status
export(int) var vitality = 1
export(int) var strength = 1
export(int) var adp = 1

#-> player gravity
export var gravity = 20

#-> player Health
var player_max_health = 100 * (vitality * 0.5)
var player_health

#-> player Stamina
var player_max_stamina = 100 * (adp * 0.5)
var player_stamina

#-> player attack
var dmg_punch = 5 * (strength * 0.5)
var dmg_melee = dmg_punch * (strength * 2)
var dmg_shoot = 20

#-> player Bullet
export(int) var player_bullet = 10

#-> player move and jump
var move_speed = 10 + adp
var max_move_speed = 200
var jump_height = -560
var move_dash = move_speed * 2
var max_dash_speed = max_move_speed * 2

#-> player status support
var idle_atck = false
var jump_status = false
var player_step = 0
var player_break = 0
var player_destination = "R"
var player_allow_atk = true
var player_empty_stamina = false
var shoot_status = true
var player_speed_restore_stamina = 10
var player_stamina_restored = 1
var player_dash = false
var player_die = false
var player_hit = false

#-> Player Contact Item
var player_contact_item = false
var item_found_name
var item_found_type
var item_found_count
var item_taked = false
var item_area

#-> Player Consequence
var stamina_jump = 5
var stamina_walk = 3
var stamina_dash = stamina_walk * 3
var stamina_atk_melee = 10
var stamina_atk_shoot = 3

#-> Player Pos Shoot
onready var pos_shoot_L = $atk_melee_area_L
onready var pos_shoot_R = $atk_melee_area_R

# --------------------------- signal to hp bar ---------------------------
signal set_max_hp(max_hp_player)
signal update_hp(player_hp)

# --------------------------- signal to stamina ---------------------------
signal set_max_stamina(max_stamina_player)
signal update_stamina(player_stamina)

# --------------------------- signal to Info Bullet ---------------------------
signal set_max_bullet(max_bullet_player)
signal update_bullet(player_bullet)

# --------------------------- signal to Info Take Items ---------------------------
signal item_take(stat)

# --------------------------- Sound ---------------------------
onready var sound_explosion = preload("res://Assets/Sound/explosion.wav")
onready var sound_melee = preload("res://Assets/Sound/melee sound.wav")
onready var sound_player_jump = preload("res://Assets/Sound/player_jump.wav")
onready var sound_player_hit = preload("res://Assets/Sound/player_hit.wav")
onready var sound_player_die = preload("res://Assets/Sound/player_die.wav")
onready var sound_player_walk = preload("res://Assets/Sound/player_walk.wav")

const rand_sound = [
	preload("res://Assets/Sound/player_wakeUp.wav"),
	preload("res://Assets/Sound/player_sleep.wav"),
	preload("res://Assets/Sound/player_yosh.wav")
]

var dmg_total = 0

# --------------------------- Setup ---------------------------
func _ready():
	player_health = player_max_health
	player_stamina = player_max_stamina
	if adp >= 100:
		max_move_speed = max_move_speed + (adp * 0.5)
	elif adp <= 99:
		max_move_speed = max_move_speed + (adp * 0.4)
	elif adp <= 80:
		max_move_speed = max_move_speed + (adp * 0.3)
	elif adp <= 70:
		max_move_speed = max_move_speed + (adp * 0.2)
	elif adp <= 50:
		max_move_speed = max_move_speed + (adp * 0.1)
	emit_signal("set_max_hp",player_max_health)
	emit_signal("update_hp",player_health)
	emit_signal("set_max_stamina",player_max_stamina)
	emit_signal("update_stamina",player_stamina)
	emit_signal("update_bullet",player_bullet)
	pass


# --------------------------- Action ---------------------------
func _physics_process(delta):
	motion.y += gravity

	#-> Move Right
	if(Input.is_action_pressed("ui_right") && idle_atck == false && player_empty_stamina == false && player_die == false && player_hit == false):
		if (player_stamina - stamina_walk) < 0:
			player_empty_stamina = true
		else:
			if player_dash == true:
				motion.x = max(move_dash,max_dash_speed)
				player_step += 3
			else:
				motion.x = max(move_speed,max_move_speed)
				player_step += 1
			AS.play("run")
			AS.flip_h = false
			player_destination = "R"
	
	#-> Move Left
	elif (Input.is_action_pressed("ui_left") && idle_atck == false && player_empty_stamina == false && player_die == false && player_hit == false):
		if (player_stamina - stamina_walk) < 0:
			player_empty_stamina = true
		else:
			if player_dash == true:
				motion.x = min(-move_dash,-max_dash_speed)
				player_step += 3
			else:
				motion.x = min(-move_speed,-max_move_speed)
				player_step += 1
			AS.play("run")
			AS.flip_h = true
			player_destination = "L"
	
	#-> Fall Down
	elif (Input.is_action_just_pressed("ui_down") && idle_atck == false && player_empty_stamina == false && player_die == false):
		set_collision_mask_bit(1,false)
	
	#-> Player Take Item
	elif (Input.is_action_just_pressed("ui_accept") && player_contact_item == true && player_die == false):
		if item_found_name == "Bullet" and item_found_type == "Weapon":
			player_bullet += item_found_count
			emit_signal("update_bullet",player_bullet)
			player_contact_item = false
			item_taked = true
			
			
	#-> Idle
	else:
		motion.x = 0
		if player_die == true:
			AS.play("die")
		else:
			if jump_status == false && idle_atck == false:
				if player_hit == false:
					AS.play("idle")
		
			# ==> Restore Stamina In Idle
			if player_stamina <= player_max_stamina:
				player_break += 1
				if player_break >= player_speed_restore_stamina:
					player_stamina += player_stamina_restored
					player_break = 0
					emit_signal("update_stamina",player_stamina)
					#print(player_stamina)
	
	# !=> Take Damage Test
	if Input.is_action_just_pressed("ui_up") and jump_status == false:
		player_health -= 3
		emit_signal("update_hp",player_health)
		pass
	
	# -> Player In Floor or Ground
	if is_on_floor():
		player_allow_atk = true
		
		# ==> Player Jump
		if Input.is_action_just_pressed("jump") && idle_atck == false && player_empty_stamina == false && player_hit == false:
			$sound_effect.set_stream(sound_player_jump)
			$sound_effect.play()
			if (player_stamina - stamina_jump) < 0:
				player_empty_stamina == true
			else:
				motion.y = jump_height
				player_stamina -=5
				jump_status = true
				emit_signal("update_stamina",player_stamina)
		else:
			jump_status = false
	
	# -> Player Not in Floor or Ground = Fall
	else:
		AS.play("jump")
		player_allow_atk = false
		
	# -> Player Attack 
	if player_allow_atk == true:
		if idle_atck == false:
			
			# ==> Attack Melee
			if Input.is_action_just_pressed("atk_melee") && player_empty_stamina == false:
				if (player_stamina - stamina_atk_melee) < 0:
					pass
				else:
					AS.play("atk_melee")
					idle_atck = true
					
					if player_destination == "R":
						atk_area_melee_R.disabled = false
					elif player_destination == "L":
						atk_area_melee_L.disabled = false
					else:
						atk_area_melee_L.disabled = false
						atk_area_melee_R.disabled = false
					$sound_effect.set_stream(sound_melee)
					$sound_effect.play()
					player_stamina -= stamina_atk_melee
					emit_signal("update_stamina",player_stamina)
			
			# ==> Attack Shoot
			elif Input.is_action_just_pressed("atk_shot") && player_empty_stamina == false && shoot_status == true:
				if (player_stamina - stamina_atk_shoot) < 0:
					pass
				else:
					AS.play("atk_shoot")
					idle_atck = true
					var Bullet = Bullet_Scene.instance()
					Bullet.dmg_value(dmg_shoot)
					get_parent().add_child(Bullet)
					if player_destination == "R":
						Bullet.create_destination(player_destination,position.y,position.x + 50)
						Bullet.from_destination = "R"
					elif player_destination == "L":
						Bullet.from_destination = "L"
						Bullet.create_destination(player_destination,position.y,position.x - 50)						
					
					player_stamina -= stamina_atk_shoot
					player_bullet -= 1
					$sound_effect.set_stream(sound_explosion)
					$sound_effect.play()
					emit_signal("update_stamina",player_stamina)
					emit_signal("update_bullet",player_bullet)
					
	#print(player_step)
	
	# -> Player Stamina when Walk
	if player_step >= 100:
		player_step  = 0
		player_stamina -= stamina_walk
		emit_signal("update_stamina", player_stamina)
	
	# -> PLayer Status Bullet
	if player_bullet == 0:
		shoot_status = false
	else:
		shoot_status = true
	
	# -> Check Player Stamina
	if player_stamina <= 0:
		player_empty_stamina = true
		player_stamina = 0
	
	motion = move_and_slide(motion,up)
	
	#print("hp=> " , player_health , " , stamina=> " , player_stamina)
	#print(player_stamina)
	#print(player_health)
	pass
	
func player_damage(amount):
	dmg_total += amount
	player_health -= amount
	$sound_effect.set_stream(sound_player_hit)
	if player_health <= 0:
		player_die = true
	else:
		player_hit = true
		AS.play("hit")
		$sound_effect.play()
	emit_signal("update_hp",player_health)
	
	pass

func _on_Area2D_body_entered(body):
	if body.name == "ground_up":
		set_collision_mask_bit(1,true)
	pass # Replace with function body.

func _on_GUI_player_die(stat):
	if stat == "die":
		AS.play("die")
		$sound_effect.set_stream(sound_player_die)
		$sound_effect.play()
	pass # Replace with function body.


func _on_AnimatedSprite_animation_finished():
	if AS.animation == "atk_melee":
		idle_atck = false
		atk_area_melee_L.disabled = true
		atk_area_melee_R.disabled = true
	elif AS.animation == "atk_shoot":
		idle_atck = false
	elif AS.animation == "die":
		get_tree().quit()
	elif AS.animation == "hit":
		player_hit = false
		AS.play("idle")
	pass # Replace with function body.

func _on_GUI_player_empty_stamina(stat):
	player_empty_stamina = stat
	pass # Replace with function body.

func _on_body_sensor_area_entered(area):
	var what_this = area.name.split("_",true,2)
	if what_this[0] == "Item":
		if item_taked == false:
			item_found_type = area.item_type
			item_found_name = area.item_name
			item_found_count = area.item_count
			player_contact_item = true
			emit_signal("item_take",true)
		else:
			area.taked()
			item_taked == false
			emit_signal("item_take",false)
	pass

func _on_body_sensor_area_exited(area):
	emit_signal("item_take",false)
	pass # Replace with function body.

func _input(event):
	#Player Dash
	if Input.is_key_pressed(KEY_SHIFT) and jump_status == false:
		player_dash = true
	else:
		player_dash = false
	pass

func _on_atk_melee_area_R_body_entered(body):
	print(body.name)
	pass # Replace with function body.
