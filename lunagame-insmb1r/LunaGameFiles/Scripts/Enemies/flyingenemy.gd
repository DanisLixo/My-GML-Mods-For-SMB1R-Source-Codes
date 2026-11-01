extends CharacterBody2D

@onready var GlobalLuna = get_node("/root/ModLoader/lunagame-insmb1r/LunaGlobal")

var SPEED: float = 40.0
var change_dir: bool = true
var functional: bool = true
var GRAVITY = 1
@export var bob_height: float = 50.0
@export var bob_speed: float = 2.0
var t: float = 0.0
@onready var start_y: float = global_position.y
@onready var collision_check: CollisionShape2D = get_node("CollisionShape2D")
@onready var anim = get_node("AnimatedSprite2D")
@onready var Enemy: Node = get_parent().get_parent()

func _physics_process(delta: float) -> void :

	if functional:
		t += delta
		var d = (sin(t * bob_speed) + 1) / 2
		global_position.y = start_y + (d * bob_height)

	if not is_on_floor() and !functional:
		velocity.y += GRAVITY

	move_and_slide()


func _on_head_damage_body_entered(body: Node2D) -> void :
	if "Luna" in body.name and functional:
		death()


func _on_player_damage_body_entered(body: Node2D) -> void :
	if "Luna" in body.name and functional:
		GlobalLuna.playerdamage = 1

func death():
	anim.play("Dead")
	GlobalLuna.score += 100
	get_node("head_damage").queue_free()
	get_node("player_damage").queue_free()
	functional = false
	velocity.x = 0
	velocity.y = -50
	get_node("death").play()
	get_node("delayer").play()




func _on_delayer_finished() -> void :
	get_node("CollisionShape2D").queue_free()
	scale.y = -1
	velocity.y = -200
	velocity.x = -50
	GRAVITY = 5
	get_node("fall").play()
	if global_position.y > 250:
		queue_free()
