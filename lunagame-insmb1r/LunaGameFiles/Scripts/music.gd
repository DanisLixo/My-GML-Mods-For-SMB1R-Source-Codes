extends AudioStreamPlayer

var speeduptime = false

@onready var GlobalLuna = get_node("/root/ModLoader/lunagame-insmb1r/LunaGlobal")

func _process(_delta: float) -> void :

	if GlobalLuna.timed:
		if GlobalLuna.time < 101:
			speeduptime = true

	if speeduptime:
		pitch_scale += 0.003
		if pitch_scale >= 1.55:
			speeduptime = false
			pitch_scale = 1.55

	if GlobalLuna.musicstopper:
		volume_db = -80
		GlobalLuna.musicstopper = false
