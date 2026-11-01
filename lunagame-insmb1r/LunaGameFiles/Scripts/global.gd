extends Node

var health: int = 4
var max_health: int = 4
var money: int = 0
var lives: int = 3
var score: int = 0
var time: int = 999
var playerdamage: int = 0
var musicstopper: bool = false
var gainedalife: bool = false
var level: int = 0
var timed: bool = false
var tick: float = 0.5
var playerdead: bool = false

var playing_luna := false:
	set(value):
		if (value):
			Global.get_node("GameHUD").hide()
			get_tree().root.content_scale_size = Vector2i(320, 240)
			get_tree().root.content_scale_aspect = Window.CONTENT_SCALE_ASPECT_KEEP
		else:
			Global.get_node("GameHUD").show()
			get_tree().root.content_scale_size = Vector2(256, 240)
			get_tree().root.content_scale_aspect = Window.CONTENT_SCALE_ASPECT_EXPAND if Settings.file.video.size == 1 else Window.CONTENT_SCALE_ASPECT_KEEP
		playing_luna = value
		

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("close_the_fucking_game") && playing_luna:
		playing_luna = false
		Global.transition_to_scene("res://Scenes/Levels/TitleScreen.tscn")

func _physics_process(_delta: float) -> void :
	if (!playing_luna):
		return
	
	if lives <= 0:
		lives = 0

	if health <= 0:
		playerdead = true

	if money > 99:
		money -= 100
		gainedalife = true

	if score == 50000:
		gainedalife = true

	if time <= 0:
		timed = false
		time = 0
