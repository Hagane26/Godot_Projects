extends KinematicBody2D

onready var AS = $AnimatedSprite
var time_bullet_explosion = 1
var motion = Vector2()
var bullet_destination
var set_pos_y = 0
var set_pos_x = 0
const bullet_speed = 500
var status

var damage
var from_destination

func create_destination(dest, pos_y, pos_x):
	bullet_destination = dest
	position.x = pos_x
	position.y = pos_y
	pass

# Called when the node enters the scene tree for the first time.

func _physics_process(delta):
	if bullet_destination == "R":
		motion.x = max((bullet_speed /2),bullet_speed)
		AS.flip_h = false
	elif bullet_destination == "L":
		motion.x = min(-(bullet_speed /2),-bullet_speed)
		AS.flip_h = true
	
	move_and_slide(motion)
	pass

func dmg_value(value):
	damage = value
	pass

func _on_sensor_body_entered(body):
	status = body.name.split("_",true,1)
	if status[0] == "ground" or status[0] == "enemy":
		if status[0] == "enemy":
			body.hit(damage,from_destination)
		AS.play("Bullet_Hit")
		AS.scale.y = 0.3
		AS.scale.x = 0.3
		$Timer.start()
	pass # Replace with function body.

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
	pass # Replace with function body.


func _on_Timer_timeout():
	AS.play("Bullet_Hit")
	for x in time_bullet_explosion:
		queue_free()
	pass # Replace with function body.
