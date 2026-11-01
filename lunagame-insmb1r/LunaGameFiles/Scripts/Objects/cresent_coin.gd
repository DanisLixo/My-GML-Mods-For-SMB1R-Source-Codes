extends Area2D

@onready var GlobalLuna = get_node("/root/ModLoader/lunagame-insmb1r/LunaGlobal")

var can_be_collected: bool = true
@onready var anim = get_node("AnimatedSprite2D")
@onready var Coin: Node = get_parent().get_parent()

func _on_body_entered(body: Node2D) -> void :
	if "Luna" in body.name and can_be_collected:

		anim.play("Collect")
		scale.x = 0.75
		can_be_collected = false
		GlobalLuna.health += 1
		GlobalLuna.score += 1000

		get_node("AudioStreamPlayer2D").play()



func _on_audio_stream_player_2d_finished() -> void :
	if can_be_collected == false:
		queue_free()
	else:
		pass
