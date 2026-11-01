extends Node

var PartnersHandler: Node = Global.get_meta("SubGlobals")["Partners"]

var input_enum: Dictionary = Global.get_meta("InputEnum")
const FRAME_LIMIT_DELAY := [60, 60, 120, 144, 240]
const ACTIONS_DEFAULT := [0, 0, 0, 0, 0]

var player: Player

var values := []
var actions := ACTIONS_DEFAULT.duplicate()

var memory_position := 0

var delay_started := false
var active := true

func _enter_tree() -> void:
	player = get_parent()

func _ready() -> void:
	memory_position = 0 - (8 * (FRAME_LIMIT_DELAY[Settings.file.video.frame_limit]/60.0)) * (player.get_meta("delay_id", -1) * 0.8) # INPUT_MEMORY_LENGTH - (INPUT_MEMORY_LENGTH / float(guys)) * player.player_id * 0.8

func _process(delta: float) -> void:
	if (!delay_started):
		_check_delay()
	else:
		memory_position = memory_position % PartnersHandler.INPUT_MEMORY_LENGTH
		if (active):
			_receive_leader_inputs()
		else:
			reset()
	
	memory_position += 1

func _receive_leader_inputs() -> void:
	actions = PartnersHandler.leader.get_meta("input_handler").actions_memory[memory_position].duplicate()

func reset() -> void:
	actions = ACTIONS_DEFAULT.duplicate()

func _check_delay() -> void:
	if (memory_position >= 0):
		delay_started = true
