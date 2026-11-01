extends CharacterBody2D

@onready var GlobalLuna = get_node("/root/ModLoader/lunagame-insmb1r/LunaGlobal")

var SPEED: float = 40.0
var change_dir: bool = true
var functional: bool = true
var GRAVITY = 9
@onready var ray_cliffcheck: RayCast2D = get_node("CliffCheck")
@onready var ray_wallcheck: RayCast2D = get_node("WallCheck")
@onready var collision_check: CollisionShape2D = get_node("CollisionShape2D")
@onready var anim = get_node("AnimatedSprite2D")
@onready var Enemy: Node = get_parent().get_parent()

func _physics_process(_delta: float) -> void :

	if not is_on_floor():
		velocity.y += GRAVITY

	if ( not ray_cliffcheck.is_colliding()) or (ray_wallcheck.is_colliding()) and functional:
		change_dir = !change_dir

	if change_dir and functional:
		velocity.x = - SPEED
		ray_cliffcheck.position = Vector2(-2, 0)
		ray_wallcheck.set_target_position(Vector2(-8, 0))
		get_node("AnimatedSprite2D").flip_h = false
	else:
		if functional:
			velocity.x = SPEED
			ray_cliffcheck.position = Vector2(2, 0)
			ray_wallcheck.set_target_position(Vector2(8, 0))
			get_node("AnimatedSprite2D").flip_h = true
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
	velocity.y = -150
	GRAVITY = 27
	get_node("death").play()


func _on_death_finished() -> void :
		get_node("CollisionShape2D").queue_free()
		scale.y = -1
		velocity.y = -200
		velocity.x = -50
		GRAVITY = 10
		get_node("fall").play()
		if global_position.y > 250:
			queue_free()
