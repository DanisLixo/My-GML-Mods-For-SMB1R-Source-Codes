extends Node

@onready var functional: bool = false
@onready var enddelay = 1.0
@onready var startdelay = 3.0

@onready var GlobalLuna = get_node("/root/ModLoader/lunagame-insmb1r/LunaGlobal")

func _ready():
	$StartDelay.start(startdelay)


func _on_start_delay_timeout() -> void :
		get_node("Sleepy Luna").show()
		get_node("Title").show()
		get_node("Version").show()
		get_node("Lunaduction").show()
		get_node("Instructions").show()
		get_node("AudioStreamPlayer").play()
		functional = true


func _process(_delta: float) -> void :
	if Input.is_action_just_pressed("ui_accept") and functional:
		functional = false
		get_node("StartGame").play()
		GlobalLuna.musicstopper = 1
		$EndDelay.start(enddelay)
		get_node("Sleepy Luna").hide()
		get_node("Title").hide()
		get_node("Version").hide()
		get_node("Lunaduction").hide()
		get_node("Instructions").hide()
	if Input.is_action_just_pressed("close_the_fucking_game") and functional:
		GlobalLuna.playing_luna = false
		Global.transition_to_scene("res://Scenes/Levels/TitleScreen.tscn")


func _on_end_delay_timeout() -> void :
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
