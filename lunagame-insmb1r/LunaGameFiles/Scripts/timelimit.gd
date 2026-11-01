extends Node
@onready var timetick: float = 1.0

@onready var GlobalLuna = get_node("/root/ModLoader/lunagame-insmb1r/LunaGlobal")

func _process(_delta: float) -> void :
	if GlobalLuna.timed:
		$TimeLimit.start(timetick)


func _on_time_limit_timeout() -> void :
	GlobalLuna.time -= 1
