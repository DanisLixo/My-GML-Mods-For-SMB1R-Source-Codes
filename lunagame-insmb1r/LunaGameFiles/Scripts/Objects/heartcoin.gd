extends CharacterBody2D

@onready var GlobalLuna = get_node("/root/ModLoader/lunagame-insmb1r/LunaGlobal")

var SPEED: float = 0.0
var change_dir: bool = true
var can_be_collected: bool = true
var GRAVITY = 9
@onready var collision_check: CollisionShape2D = get_node("CollisionShape2D")
@onready var anim = get_node("AnimatedSprite2D")
@onready var PowerUp: Node = get_parent().get_parent()

func _physics_process(_delta: float) -> void :

	if not is_on_floor():
		velocity.y += GRAVITY

	move_and_slide()

func _on_collect_range_body_entered(body: Node2D) -> void :
	if "Luna" in body.name and can_be_collected:
		GlobalLuna.health = GlobalLuna.max_health
		get_node("CollisionShape2D").queue_free()
		GRAVITY = 18
		anim.play("Collect")
		can_be_collected = false
		get_node("collect range").queue_free()
		velocity.x = 0
		velocity.y = -400
		GlobalLuna.score += 1000
		GlobalLuna.health = 4
		GlobalLuna.gainedalife = true

		get_node("AudioStreamPlayer2D").play()


func _on_audio_stream_player_2d_finished() -> void :
	if can_be_collected == false:
		queue_free()
	else:
		pass
