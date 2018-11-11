extends KinematicBody2D

const CENTER = Vector2(0, 0)
const UP = Vector2(0, -1)
const DOWN = Vector2(0, 1)
const LEFT = Vector2(-1, 0)
const RIGHT = Vector2(1, 0)

export var SPEED = 50
export var shootTimer = 0.5
export var xtBulletA = false
export var xtBulletB = false

var sprite
var anim

var moveDir = Vector2(0, 0)
var state = "normal"
var facingDir = Vector2(0, 1)
var bullet = load("res://Scenes/Bullet.tscn")

var shootHold = false
var shootCoolDown = 0

func _ready():
	
	sprite = $Sprite
	anim = $AnimationPlayer
	
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

	shoot_cool_down_loop(delta)
	
	pass

func normal_controls_loop():
	
	var UP = Input.is_action_pressed("ui_up")
	var DOWN = Input.is_action_pressed("ui_down")
	var LEFT = Input.is_action_pressed("ui_left")
	var RIGHT = Input.is_action_pressed("ui_right")
	var SHOOT = Input.is_action_pressed("ui_shoot")
	
	if SHOOT:
		if shootCoolDown <= 0:
			shoot_bullets()
	else:
		shootHold = false
	
	check_direction(UP, LEFT, RIGHT, DOWN)
	
	moveDir = Vector2(int(RIGHT) - int(LEFT), int(DOWN) - int(UP))
	
	pass

func check_direction(var UP, var LEFT, var RIGHT, var DOWN):
	
	if UP && not LEFT && not RIGHT && not DOWN:
		facingDir = Vector2(0, -1)
	elif not UP && not LEFT && not RIGHT && DOWN:
		facingDir = Vector2(0, 1)
	elif not UP && not LEFT && RIGHT && not DOWN:
		facingDir = Vector2(1, 0)
	elif not UP && LEFT && not RIGHT && not DOWN:
		facingDir = Vector2(-1, 0)
	
	pass

func normal_movement_loop():
	
	var motion = moveDir.normalized() * SPEED
	move_and_slide(motion, Vector2(0, 0))
	
	pass

func normal_animation_loop():
	
	var animName = ""
	if moveDir == Vector2(0, 0):
		animName = "stand"
	else:
		animName = "walk"
	
	choose_animation(animName)
	
	pass

func choose_animation(var animNamePar):
	
	var dir = ""
	match facingDir:
		Vector2(0, 1):
			dir = "front_"
		Vector2(0, -1):
			dir = "back_"
		Vector2(-1, 0):
			dir = "right_"
			sprite.flip_h = true
		Vector2(1, 0):
			dir = "right_"
			sprite.flip_h = false
	
	if anim.current_animation != dir + animNamePar:
		anim.play(dir + animNamePar)
	
	pass

func hurt_loop():
	
	
	
	pass

func hurt_animation_loop():
	
	
	
	pass

func get_diagonals(var dir):
	
	var diagonals = []
	
	match dir:
		UP:
			diagonals.append(UP + LEFT)
			diagonals.append(UP + RIGHT)
		DOWN:
			diagonals.append(DOWN + LEFT)
			diagonals.append(DOWN + RIGHT)
		RIGHT:
			diagonals.append(RIGHT + UP)
			diagonals.append(RIGHT + DOWN)
		LEFT:
			diagonals.append(LEFT + UP)
			diagonals.append(LEFT + DOWN)
	
	return diagonals

func get_bullets_pos(var dir):
	
	var bulletPos = []
	
	if dir.y == 0:
		bulletPos.append(Vector2($BulletPos.global_position.x, $BulletPos.global_position.y - 4))
		bulletPos.append(Vector2($BulletPos.global_position.x, $BulletPos.global_position.y + 4))
	else:
		bulletPos.append(Vector2($BulletPos.global_position.x - 4, $BulletPos.global_position.y))
		bulletPos.append(Vector2($BulletPos.global_position.x + 4, $BulletPos.global_position.y))
	
	return bulletPos

func shoot_bullets():
	
	if xtBulletA && xtBulletB:
		var diag = get_diagonals(facingDir)
		instantiate_bullet($BulletPos.global_position, facingDir)
		instantiate_bullet($BulletPos.global_position, diag[0])
		instantiate_bullet($BulletPos.global_position, diag[1])
	elif xtBulletA:
		var bulletsPos = get_bullets_pos(facingDir)
		instantiate_bullet(bulletsPos[0], facingDir)
		instantiate_bullet(bulletsPos[1], facingDir)
	elif xtBulletB:
		instantiate_bullet($BulletPos.global_position, facingDir)
		instantiate_bullet($BulletPos.global_position, facingDir * -1)
	else:
		instantiate_bullet($BulletPos.global_position, facingDir)
	
	shootCoolDown = shootTimer

func shoot_cool_down_loop(delta):
	
	if shootCoolDown > 0:
		shootCoolDown -= delta

func instantiate_bullet(var bulletPos, var direction):
	
	var instance = bullet.instance()
	instance.set_name("Bullet")
	get_parent().add_child(instance)
	instance.global_position = bulletPos
	instance.get_child(0).motionDir = direction
	
	pass
