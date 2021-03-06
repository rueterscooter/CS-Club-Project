extends "res://Scripts/Game_Scripts/entity.gd"

export var shootTimer = 0.5
export var xtBulletA = false
export var xtBulletB = false

var bullet = load("res://Scenes/Bullet.tscn")

var shootHold = false
var shootCoolDown = 0

func _ready():
	
	sprite = $Sprite
	anim = $AnimationPlayer
	dmgAnim = $HurtAnimPlayer
	
	pass

func _physics_process(delta):

	match state:
		"normal":
			normal_controls_loop()
			normal_movement_loop()
			normal_animation_loop()
			hurt_cool_down_loop(delta)
		"hurt":
			hurt_loop(delta)
			hurt_movement_loop()
	
	hurt_animation_loop()
	shoot_cool_down_loop(delta)
	
	pass

func normal_controls_loop():
	
	var up = Input.is_action_pressed("ui_up")
	var down = Input.is_action_pressed("ui_down")
	var left = Input.is_action_pressed("ui_left")
	var right = Input.is_action_pressed("ui_right")
	var shoot = Input.is_action_pressed("ui_shoot")
	
	if shoot:
		if shootCoolDown <= 0:
			shoot_bullets()
	else:
		shootHold = false
	
	check_direction(up, left, right, down)
	
	moveDir = Vector2(int(right) - int(left), int(down) - int(up))
	
	pass

func check_direction(var up, var left, var right, var down):
	
	if up && not left && not right && not down:
		facingDir = Vector2(0, -1)
	elif not up && not left && not right && down:
		facingDir = Vector2(0, 1)
	elif not up && not left && right && not down:
		facingDir = Vector2(1, 0)
	elif not up && left && not right && not down:
		facingDir = Vector2(-1, 0)
	
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
		DOWN:
			dir = "front_"
		UP:
			dir = "back_"
		LEFT:
			dir = "right_"
			sprite.flip_h = true
		RIGHT:
			dir = "right_"
			sprite.flip_h = false
	
	if anim.current_animation != dir + animNamePar:
		anim.play(dir + animNamePar)
	
	pass

func hurt_cool_down_loop(delta):

	if invincible && hurtCDTimer > 0:
		hurtCDTimer -= delta
		if hurtCDTimer <= 0:
			invincible = false
			dmgAnim.stop(true)

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


func _on_Hitbox_area_entered(area):
	
	if area.get_parent().get("type") == "enemy" && !invincible:
		damaged_by(area.get_parent())
		dmgAnim.play("dmg")
		# The line below calls the shake function in the GameCam script
		# this line will ONLY work here. Copying and pasting WILL NOT WORK
		get_parent().get_parent().currentRoom.get_child(0).shake(0.5, 15, 5)
		hurtCDTimer = hurtCDTime
		
	pass
