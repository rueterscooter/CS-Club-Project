extends KinematicBody2D

const CENTER = Vector2(0, 0)
const UP = Vector2(0, -1)
const DOWN = Vector2(0, 1)
const LEFT = Vector2(-1, 0)
const RIGHT = Vector2(1, 0)

export var speed = 0

var sprite
var anim

var state = "normal"

var moveDir = Vector2(0, 0)
var facingDir = Vector2(0, 1)

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