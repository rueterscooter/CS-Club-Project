extends KinematicBody2D

var speed = 100
var motionDir = Vector2(0,0)
var timeMax = 1
var timer = 0

func _physics_process(delta):
	
	move_and_slide(motionDir.normalized() * speed)
	
	if timer < timeMax:
		timer += delta
		if timer >= timeMax:
			destroy_obj()
	
	pass

func destroy_obj():
	
	get_parent().remove_child(self)
	
	pass