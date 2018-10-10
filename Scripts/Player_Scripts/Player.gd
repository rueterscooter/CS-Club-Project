extends KinematicBody2D

const SPEED = 70

var moveDir = Vector2(0, 0)
var state = "normal"
var facing = "front"

#func _ready():
#
#
#
#	pass

func _physics_process(delta):

	match state:
		"normal":
			normal_controls_loop()
			normal_movement_loop()
			normal_animation_loop()

	pass

func normal_controls_loop():
	
	
	
	pass

func normal_movement_loop():
	
	var motion = moveDir.normalized() * SPEED
	move_and_slide(motion, Vector2(0, 0))
	
	pass

func normal_animation_loop():
	
	
	
	pass

func damage_loop():
	
	
	
	pass