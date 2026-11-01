extends Object

var gameplayInjuries := [
	"small_jump",
	"big_jump", 
	"walk",
	"run",
	"skid",
	"pipe",
	"bump",
	"damage",
	"kick",
	"fireball",
]

var semiGPInjuries := [
	"walk",
	"run",
	"skid",
	"pipe",
	"damage",
	"kick",
]

func play_sfx(c: ModLoaderHookChain, stream_name = "", position := Vector2.ZERO, pitch := 1.0, can_overlap := true) -> void:
	var partnerDetected := 0
	
	for i in c.reference_object.get_tree().get_nodes_in_group("Players-AI"):
		if (floor(abs(position)) == floor(abs(i.global_position))):
			if (semiGPInjuries.has(stream_name)):
				partnerDetected = 1
			elif (gameplayInjuries.has(stream_name)):
				partnerDetected = 2
	
	if ((partnerDetected == 1 
	&& (Settings.file.partners.cpu_muted >= 1 || Settings.file.partners.copy_muted >= 1)) 
	|| (partnerDetected == 2 && (Settings.file.partners.cpu_muted >= 2))):
		return
	
	c.execute_next_async([stream_name, position, pitch, can_overlap])
