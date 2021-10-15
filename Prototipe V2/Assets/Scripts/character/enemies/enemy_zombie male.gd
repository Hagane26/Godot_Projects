extends KinematicBody2D

var motion = Vector2()
const up = Vector2(0,-1)

onready var AS = $AnimatedSprite
onready var change_up = $Timer

onready var pdl = $player_detect_L/CollisionShape2D
onready var pdr = $player_detect_R/CollisionShape2D
onready var al = $action_L/CollisionShape2D
onready var ar = $action_R/CollisionShape2D
onready var area_atk_L = $atk_area_R/CollisionShape2D
onready var area_atk_R = $atk_area_L/CollisionShape2D
onready var dgL = $detect_gound_L/CollisionShape2D
onready var dgR = $detect_gound_R/CollisionShape2D

# ----------------------- Enemy Status -----------------------
var gravity = 20

# -> enemy health
export(int) var max_health = 100
var current_health

# -> enemy move
var dash = 100
var move_speed = 10
var max_move_speed = 30
var jump_height = -560

# -> enemy status
var attacking = false
var player_inArea = []

# -> variable to randomize
var rng = RandomNumberGenerator.new()
var desination = ["L","R","Idle"]
var now_destination

# -> variable support
var sensor_see
var status_change_up = false
var dead = false
var count = 0

func randomize_destination():
	rng.randomize()
	now_destination = desination[rng.randi_range(0,desination.size()-1)]
	
	pass

func _ready():
	randomize_destination()
	current_health = max_health
	pass # Replace with function body.

func _physics_process(delta):
	motion.y += gravity
	
	if now_destination == "R" and attacking == false:
		motion.x = max(move_speed,max_move_speed)
		sensor_change_pos("R")
		AS.flip_h = false
		AS.play("walk")
		
	elif now_destination == "L" and attacking == false:
		motion.x = min(-move_speed,-max_move_speed)
		sensor_change_pos("L")
		AS.flip_h = true
		AS.play("walk")
		
	elif now_destination == "Idle":
		motion.x = 0
		if dead == true:
			AS.play("dead")
		elif attacking == true:
			AS.play("attack1")
		else:
			AS.play("idle")
			active_timer()
	
	motion = move_and_slide(motion,up)
	pass

func sensor_change_pos(val):
	var status1
	var status2
	match(val):
		"L":
			status1 = false
			status2 = true
		"R":
			status1 = true
			status2 = false
	
	#sensor left 
	pdl.disabled = status1
	area_atk_L.disabled = status1
	dgL.disabled = status1
	
	#sensor right 
	pdr.disabled = status2
	area_atk_R.disabled = status2
	dgR.disabled = status2
	
	pass

func active_timer():
	if status_change_up == false:
			status_change_up = true
			change_up.start()
	pass

func hit(dmg,destination):
	current_health -= dmg
	if current_health <= 0:
		dead = true
		now_destination = "Idle"
	else:
		if destination == "R":
			now_destination = "L"
		elif destination == "L":
			now_destination = "R"
	pass

func _on_sensor_mata_L_body_entered(body):
	sensor_see = body.name.split("_",true,1)
	if sensor_see[0] == "player":
		max_move_speed += dash
		now_destination = "L"
	pass # Replace with function body.

func _on_sensor_mata_R_body_entered(body):
	sensor_see = body.name.split("_",true,1)
	if sensor_see[0] == "player":
		max_move_speed += dash
		now_destination = "R"
	pass # Replace with function body.

func _on_player_detect_L_body_exited(body):
	sensor_see = body.name.split("_",true,1)
	if sensor_see[0] == "player":
		max_move_speed -= dash
		randomize_destination()
	pass # Replace with function body.

func _on_player_detect_R_body_exited(body):
	sensor_see = body.name.split("_",true,1)
	if sensor_see[0] == "player":
		max_move_speed -= dash
		randomize_destination()
	pass # Replace with function body.

func _on_action_R_body_entered(body):
	sensor_see = body.name.split("_",true,1)
	if sensor_see[0] == "ground":
		if now_destination == "R":
			now_destination = "L"
			active_timer()
	elif sensor_see[0] == "player":
		attacking = true
		now_destination = "Idle"
		AS.flip_h = false
		player_inArea.append(body.get_path())
	pass # Replace with function body.

func _on_action_L_body_entered(body):
	sensor_see = body.name.split("_",true,1)
	if sensor_see[0] == "ground":
		if now_destination == "L":
			now_destination = "R"
			active_timer()
	elif sensor_see[0] == "player":
		attacking = true
		now_destination = "Idle"
		AS.flip_h = true
		player_inArea.append(body.get_path())
	pass # Replace with function body.

func _on_Timer_timeout():
	count += 1
	if count >= 3:
		randomize_destination()
		status_change_up = false
		count = 0
		change_up.stop()
	pass # Replace with function body.


func _on_AnimatedSprite_animation_finished():
	if AS.animation == "dead":
		queue_free()
	elif AS.animation == "attack1":
		AS.play("attack1-2")
		var player_path = player_inArea.front()
		get_node(player_path).player_damage(5)
	elif AS.animation == "attack1-2":
		AS.play("attack1")
	pass # Replace with function body.


func _on_action_R_body_exited(body):
	sensor_see = body.name.split("_",true,1)
	if sensor_see[0] == "player":
		attacking = false
		
	pass # Replace with function body.


func _on_action_L_body_exited(body):
	sensor_see = body.name.split("_",true,1)
	if sensor_see[0] == "player":
		attacking = false
	pass # Replace with function body.
