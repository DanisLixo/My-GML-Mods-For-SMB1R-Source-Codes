extends Node

var walk_speed := 43.0
var gotIntoPipe := false

@onready var PartnerSettings = Settings.get_meta("PartnersMod")

func _physics_process(delta: float) -> void:
	var obj: PlayerSprite = get_parent()
	if (obj.global_position.x >= 27.2):
		if (!gotIntoPipe):
			if (PartnerSettings.file.cpu_options.muted >= 2 || PartnerSettings.file.copy_options.muted >= 1):
				AudioManager.play_sfx("pipe", obj.global_position)
			obj.animation = "PipeWalk"
			gotIntoPipe = true
	if (obj.global_position.x < 40.0):
		obj.global_position.x += ((walk_speed / delta) * delta) * delta
	else:
		obj.visible = false
