extends KinematicBody2D

const CENTER = Vector2(0, 0)
const UP = Vector2(0, -1)
const DOWN = Vector2(0, 1)
const LEFT = Vector2(-1, 0)
const RIGHT = Vector2(1, 0)

export var type = ""
export var speed = 0
export var hp = 0

var sprite
var anim
var dmgAnim

var state = "normal"
var invincible = false

var moveDir = CENTER
var facingDir = DOWN

var knockbackDir = Vector2(0, 0)
var knockbackSpeed = 75

var hurtTime = 0.2
var hurtTimer = 0
var hurtCDTime = 0.5
var hurtCDTimer = 0

func randDir():
	
	var rand = randi()%4 + 1
	
	match rand:
		1:
			return LEFT
		2:
			return RIGHT
		3:
			return UP
		4:
			return DOWN

func normal_movement_loop():
	
	var motion = moveDir.normalized() * speed
	move_and_slide(motion, Vector2(0, 0))
	
	pass

func damaged_by(var obj):
	
	if abs(obj.global_position.x - global_position.x) > abs(obj.global_position.y - global_position.y):
		knockbackDir = Vector2(-(obj.global_position.x - global_position.x), 0).normalized()
	else:
		knockbackDir = Vector2(0, -(obj.global_position.y - global_position.y)).normalized()
	
	hurtTimer = hurtTime
	state = "hurt"
	invincible = true
	hp -= 1
	
	pass

func hurt_loop(delta):
	
	if hurtTimer > 0:
		hurtTimer -= delta
		if hurtTimer <= 0:
			state = "normal"
			if type == "enemy":
				invincible = false
			else:
				dmgAnim.play("blink")
#			invincible = false
	
	pass

func hurt_movement_loop():
	
	var motion = knockbackDir.normalized() * knockbackSpeed
	move_and_slide(motion, Vector2(0, 0))
	
	pass

func destroy():
	
	get_parent().remove_child(self)
	
	pass