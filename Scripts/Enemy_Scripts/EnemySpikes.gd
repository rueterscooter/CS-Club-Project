extends "res://Scripts/Game_Scripts/entity.gd"

export var moveTimer = 0.5

var moveTime = 0

func _ready():
	
	speed = 25
	sprite = $Sprite
	
	pass

func _physics_process(delta):
	
	if moveTime < moveTimer:
		moveTime += delta
		if moveTime >= moveTimer:
			moveTime = 0
			moveDir = randDir()
	
	normal_movement_loop()
	
	pass