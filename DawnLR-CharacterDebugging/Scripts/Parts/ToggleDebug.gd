extends Node

static var enabled := false

signal has_toggled(nowEnabled: bool)

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _process(delta: float) -> void:
	if (Input.is_action_just_pressed("debug_unlock")):
		enabled = !enabled
		has_toggled.emit(enabled)
