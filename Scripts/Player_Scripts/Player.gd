extends KinematicBody2D

const SPEED = 50

var sprite

var moveDir = Vector2(0, 0)
var state = "normal"
var facingDir = Vector2(0, 1)
var bullet = load("res://Scenes/Bullet.tscn")

func _ready():
	
	sprite = $AnimatedSprite
	
	pass

func _physics_process(delta):

	match state:
		"normal":
			normal_controls_loop()
			normal_movement_loop()
			normal_animation_loop()
		"hurt":
			hurt_loop()
			hurt_animation_loop()

	pass

func normal_controls_loop():
	
	var UP = false
	var DOWN = Input.is_action_pressed("ui_down")
	var LEFT = false
	var RIGHT = false
	var SHOOT = Input.is_action_just_pressed("ui_shoot")
	
	if SHOOT:
		instantiate_bullet()
	
	moveDir = Vector2(int(RIGHT) - int(LEFT), int(DOWN) - int(UP))
	
	pass

func normal_movement_loop():
	
	var motion = moveDir.normalized() * SPEED
	move_and_slide(motion, Vector2(0, 0))
	
	pass

func normal_animation_loop():
	
	
	
	pass

func hurt_loop():
	
	
	
	pass

func hurt_animation_loop():
	
	
	
	pass

func instantiate_bullet():
	
	var instance = bullet.instance()
	instance.set_name("Bullet")
	self.add_child(instance)
	instance.position = position
	instance.get_child(0).motionDir = facingDir
	
	pass