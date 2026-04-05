extends CanvasLayer

var isPlaying = false

signal peterTransition_finished

@onready var sprite := $Control/AnimatedSprite2D
@onready var audio := $PeterTransition

func _ready() -> void:
	$Control.hide()
	$ColorRect.hide()

func play_transition() -> void:
	if (isPlaying): return
	$ColorRect.show()
	$Control.show()
	isPlaying = true
	sprite.play("default")
	audio.play()
	await sprite.animation_finished
	sprite.scale.x *= -1
	sprite.play_backwards("default")
	await sprite.animation_finished
	$Control.hide()
	$ColorRect.hide()
	
	peterTransition_finished.emit()
	
	await get_tree().create_timer(0.5, true).timeout
	isPlaying = false
	
	
