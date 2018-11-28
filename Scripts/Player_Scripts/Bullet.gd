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

func _on_HitBox_area_entered(area):
	
	if area.get_parent().get("type") == "enemy":
		area.get_parent().destroy()
		# The line below calls the shake function in the GameCam script
		# this line will ONLY work here. Copying and pasting WILL NOT WORK
		get_parent().get_parent().get_parent().currentRoom.get_child(0).shake(0.5, 8, 2)
	
	pass
