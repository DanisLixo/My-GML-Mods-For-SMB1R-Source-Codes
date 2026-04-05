extends Node

@export var tipText = "Press open_partner_config for Partner settings!"
@onready var actualSettings = $PartnerSelect

var active = false
var charSelects: Array[Control]
var curCharSelect: Control

signal a

func _ready() -> void:
	curCharSelect = charSelects[0]

func _process(_delta: float) -> void:
	if (!$PartnerSelect.active):
		for sel in charSelects:
			if (sel.active):
				curCharSelect = sel
	
	if (!InputMap.has_action("open_partner_config")):
		fix_inputmap()
	if (Input.is_action_just_pressed("open_partner_config") && !actualSettings.active && curCharSelect.active):
		actualSettings.open()

func fix_inputmap() -> void:
	InputMap.add_action("open_partner_config")
	
	var new = [InputEventKey.new(), InputEventJoypadButton.new()]
	new[0].keycode = KEY_P
	new[1].button_index = JOY_BUTTON_Y
	
	InputMap.action_add_event("open_partner_config", new[0])
	InputMap.action_add_event("open_partner_config", new[1])

func ablueh():
	if (curCharSelect != null):
		curCharSelect.close()

func open():
	if (curCharSelect != null):
		curCharSelect.open()
