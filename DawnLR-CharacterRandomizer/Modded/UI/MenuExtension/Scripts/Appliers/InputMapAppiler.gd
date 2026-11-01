extends Node

var input_nodes := []

var actions := []

static var deadzone := 0.5

@export_enum("Keyboard", "Controller") var type := 0

func _ready() -> void:
	get_input_nodes()
	load_inputs()

func get_input_nodes() -> void:
	actions.clear()
	input_nodes.clear()
	
	for i in get_parent().get_children():
		if i is SelectableInputOption && i.type == type:
			for n in i.action_names:
				actions.append(n)
			input_nodes.append(i)

func _process(_delta: float) -> void:
	if Global.multibind_action_just_pressed("ui_reset_keybindings"):
		load("res://mods-unpacked/DawnLR-CharacterRandomizer/Singletons/InputMapInjection.gd").new().start()
		
		save_inputs()
		Settings.save_settings()
		load_inputs()

func load_inputs() -> void:
	for i in input_nodes:
		for action_name in i.action_names:
			var action = action_name
			var value = Settings.file[["mods_keyboard", "mods_controller"][type]].get(action, null)
			if value == null:
				continue
			if value is Array:
				if value.size() < 2:
					value.append(null)
				var idx := 0
				for x in value:
					bind_value_to_event(i, x, idx)
					idx += 1
			else:
				bind_value_to_event(i, value, 0)
		i.update_value()

func bind_value_to_event(input_node, value, idx := 0) -> void:
	var event: InputEvent = null
	if value == null:
		return
	if value is String:
		if value == "":
			input_node.map_event_to_action(null, idx)
			return
	if type == 0:
		event = InputEventKey.new()
		event.keycode = OS.find_keycode_from_string(value)
	elif type == 1:
		if value is String:
			var array = value.split(",")
			event = InputEventJoypadMotion.new()
			event.axis = int(array[0])
			event.axis_value = int(array[1])
		elif value is int:
			event = InputEventJoypadButton.new()
			event.button_index = value
	input_node.map_event_to_action(event, idx)

func update_starting_values() -> void:
	load_inputs()
 
func save_inputs() -> void:
	for i in actions:
		var event = null
		var events := []
		if i.contains("ui") or i == "pause":
			event = InputMap.action_get_events(i)
		else:
			event = InputMap.action_get_events(i + "_0")
		for x in event:
			if type == 0 and x is InputEventKey:
				events.append(get_str_for_event(x))
			elif type == 1 and (x is InputEventJoypadButton or x is InputEventJoypadMotion):
				events.append(get_str_for_event(x))
		Settings.file[["mods_keyboard", "mods_controller"][type]][i] = events

func get_str_for_event(event: InputEvent):
	var rep = ""
	if event is InputEventKey:
		rep = OS.get_keycode_string(event.keycode)
	elif event is InputEventJoypadButton:
		rep = event.button_index
	elif event is InputEventJoypadMotion:
		rep = str(event.axis) + "," + str(event.axis_value)
	return rep
