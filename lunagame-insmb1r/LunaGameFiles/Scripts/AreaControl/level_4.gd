extends Node2D

var StopTimer = false

@onready var GlobalLuna = get_node("/root/ModLoader/lunagame-insmb1r/LunaGlobal")

func _ready() -> void :
	GlobalLuna.level = 4
	GlobalLuna.health = 4
	GlobalLuna.time = 300
	GlobalLuna.timed = true

func _process(_delta: float) -> void :
		if GlobalLuna.timed == true and $Tick.is_stopped():
			$Tick.start(GlobalLuna.tick)

		if GlobalLuna.playerdead == true:
			StopTimer = true

func _on_tick_timeout() -> void :
	if StopTimer == false:
		GlobalLuna.time -= 1
