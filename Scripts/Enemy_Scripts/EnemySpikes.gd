extends "res://Scripts/Game_Scripts/entity.gd"

export var moveTimer = 0.5

var moveTime = 0

func _ready():
	
	sprite = $Sprite
	
	pass

func _physics_process(delta):
	
	match state:
		"normal":
			state_normal_loop(delta)
#		"hurt":
#			hurt_loop(delta)
	
	normal_movement_loop()
	
	pass

func state_normal_loop(delta):
	
	if moveTime < moveTimer:
		moveTime += delta
		if moveTime >= moveTimer:
			moveTime = 0
			moveDir = randDir()
	
	pass