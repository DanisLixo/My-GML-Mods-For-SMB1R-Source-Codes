extends Node

@onready var GlobalLuna = get_node("/root/ModLoader/lunagame-insmb1r/LunaGlobal")

@onready var functional: bool = true
@onready var delay: float = 1.0

func _process(_delta: float) -> void :
	if Input.is_action_just_pressed("ui_accept") and functional:
		functional = false
		get_node("StartGame").play()
		GlobalLuna.musicstopper = 1
		$Delay.start(delay)
		get_node("Sleepy Luna").hide()
		get_node("Title").hide()
		get_node("Version").hide()
		get_node("Lunaduction").hide()
		get_node("Instructions").hide()




func _on_delay_timeout() -> void :
	get_tree().change_scene_to_file("res://mods-unpacked/lunagame-insmb1r/LunaGameFiles/Scenes/Levels/Level1.tscn")
