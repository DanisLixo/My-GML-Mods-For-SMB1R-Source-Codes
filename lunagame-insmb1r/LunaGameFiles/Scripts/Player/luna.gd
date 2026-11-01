extends CharacterBody2D

@onready var GlobalLuna = get_node("/root/ModLoader/lunagame-insmb1r/LunaGlobal")

@onready var anim = get_node("AnimatedSprite2D")
@onready var Luna: Node = get_parent().get_parent()
@onready var onladder = false


var SPEED: float = 50.0

var MOVING: bool = false
var ACCEL: float = 6
var GRAVITY = 9
var HURT = false
var DEAD = false

var JUMP_VELOCITY: float = -300
var FALL_VELOCITY: float = 300


var canbehurt = true
var iframes: float = 3.0

var coyotetime: float = 0.35
var canjump = false

var hurttime: float = 0.75
var onfloor: bool = true


var RUNNING: bool = false



var Above0: bool = true
var YouAreInControl: bool = true


var direction: = Input.get_axis("move_left_0", "move_right_0")


func _physics_process(_delta: float) -> void :
	if GlobalLuna.gainedalife:
		get_node("1-UP").play()
		GlobalLuna.lives += 1
		GlobalLuna.gainedalife = false
	if not is_on_floor():
		velocity.y += GRAVITY
		onfloor = false
		if velocity.y >= FALL_VELOCITY:
			velocity.y = FALL_VELOCITY
	if is_on_floor():
		onfloor = true
	if is_on_floor() and canjump == false:
		canjump = true
	elif canjump == true and $CoyoteTimer.is_stopped():
		$CoyoteTimer.start(coyotetime)
	if GlobalLuna.playerdead == false:
		if HURT == false:
			if velocity.y < 0:
				anim.play("Jumping")
			elif velocity.y > 50:
				anim.play("Falling")
		elif HURT:
			if velocity.y < 0:
				anim.play("Hurt")
			elif velocity.y > 50:
				anim.play("Hurt")
	if Global.player_action_pressed("jump") and YouAreInControl and canjump:
		canjump = false
		get_node("jump").play()
		velocity.y = JUMP_VELOCITY
	if direction and YouAreInControl:
		if direction > 0:
			velocity.x = move_toward(velocity.x, SPEED, ACCEL)
		elif direction < 0:
			velocity.x = move_toward(velocity.x, - SPEED, ACCEL)
		MOVING = true
		if is_on_floor():
				if velocity.x != 0 and !RUNNING:
					anim.play("Walking")
				if RUNNING:
					anim.play("Running")
	else:
		velocity.x = move_toward(velocity.x, 0, ACCEL)
		MOVING = false
		if is_on_floor() and GlobalLuna.playerdead == false and YouAreInControl:
				anim.play("Stand")
				if Global.player_action_pressed("move_down"):
					anim.play("Duck")
				if Global.player_action_pressed("move_up"):
					anim.play("Looking Up")
	if Global.player_action_pressed("run") and YouAreInControl:
		if MOVING:
			SPEED = 200.0
			ACCEL = 10
			RUNNING = true
	else:
		if MOVING:
			SPEED = 100.0
			ACCEL = 10
			RUNNING = false
		else:
			if MOVING == false and HURT == false:
				ACCEL = 10
				RUNNING = false
	direction = Input.get_axis("move_left_0", "move_right_0")
	if YouAreInControl:
		if direction < 0:
			anim.flip_h = true
		elif direction > 0:
			anim.flip_h = false

	move_and_slide()
	if GlobalLuna.playerdamage == 1 and canbehurt:
		GlobalLuna.health -= 1

		canbehurt = false
		damage()
		GlobalLuna.playerdamage = 0
	elif GlobalLuna.playerdamage == 1 and canbehurt == false:
		GlobalLuna.playerdamage = 0
	if global_position.y > 0 and Above0 and GlobalLuna.playerdead == false:
		GlobalLuna.playerdead = true
	if GlobalLuna.time == 0 and GlobalLuna.playerdead == false:
		GlobalLuna.playerdead = true
	if GlobalLuna.playerdead and DEAD == false:
		death()
	if global_position.y > 1000:
		level_reset()

func _on_coyote_timer_timeout() -> void :
	canjump = false

func _on_i_frames_timeout() -> void :
	self.modulate.a8 = 255
	canbehurt = true
	self.show()


func _input(event):
	if GlobalLuna.playerdead == false and HURT == false and event.is_action_released("jump_0"):
		if velocity.y < 0.0:
			velocity.y *= 0.5


func damage() -> void :
	YouAreInControl = false
	canjump = false
	HURT = true
	ACCEL = 0
	velocity.y = -200
	get_node("playerhurt").play()
	if anim.flip_h == false:
		velocity.x = -75
	elif anim.flip_h == true:
		velocity.x = 75
	$HurtTimer.start(hurttime)


func _on_hurt_timer_timeout() -> void :
	if canbehurt == false and DEAD == false and $IFrames.is_stopped():
		YouAreInControl = true
		HURT = false
		ACCEL = 10
		$IFrames.start(iframes)
		self.modulate.a8 = 128



func death() -> void :
	GlobalLuna.musicstopper = true
	GlobalLuna.timed = false
	DEAD = true
	self.show()
	self.modulate.a8 = 255
	GlobalLuna.playerdead = true
	GRAVITY = 9
	FALL_VELOCITY = 9999
	ACCEL = 0
	velocity.x = 0
	anim.play("Death")
	velocity.y = -400
	get_node("CollisionShape2D").disabled = true
	YouAreInControl = false
	get_node("playerdeath").play()
	get_node("fall").play()



func level_reset():
	GlobalLuna.lives -= 1
	GlobalLuna.health = 4
	if GlobalLuna.lives >= 1:
		GlobalLuna.playerdead = false
		get_tree().reload_current_scene()
	elif GlobalLuna.lives < 1:
		pass
