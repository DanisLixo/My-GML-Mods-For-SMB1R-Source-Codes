extends Label

@onready var parent := get_parent()

var color := 0
var colors := [Color.WHITE, Color.hex(0xf83910ff), Color.hex(0x1a912eff), Color.hex(0x5050ffff), Color.hex(0xff54d3ff)]

enum INPUT_DEVICE {
	KEYBOARDMOUSE, CONTROLLER
}
var lastInputDevice = INPUT_DEVICE.KEYBOARDMOUSE
var device_name = ""

func _ready() -> void:
	Global.frame_rule.connect((func(): color += 1))
	
func _process(_delta: float) -> void:
	update_tip()
	
	color %= colors.size()
	self_modulate = colors[color]

func _input(event: InputEvent) -> void:
	if (event is InputEventKey 
	|| event is InputEventMouseButton 
	|| event is InputEventMouseMotion):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		lastInputDevice = INPUT_DEVICE.KEYBOARDMOUSE
	elif (event is InputEventJoypadButton 
	|| event is InputEventJoypadMotion):
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		lastInputDevice = INPUT_DEVICE.CONTROLLER
		device_name = Input.get_joy_name(event.device)

func update_tip() -> void:
	var current_device_brand = 0
	if device_name.to_upper().contains("NINTENDO") or device_name.to_upper().contains("SWITCH") or device_name.to_upper().contains("WII"):
		current_device_brand = 1
	elif device_name.to_upper().contains("PS") or device_name.to_upper().contains("PLAYSTATION"):
		current_device_brand = 2
	else:
		current_device_brand = 0
	var input: String = "Up"
	if (!parent.charHasConfig):
		text = parent.tipTextShort
	else:
		text = parent.tipText.replace("ui_up", input)
