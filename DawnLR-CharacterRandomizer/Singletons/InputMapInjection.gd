extends Object

var keys_to_add := {
	"ui_toggle_randomizer": {
		"deadzone": 0.2,
		"keyboard": ["F6"],
		"controller": []
	}
}

func start() -> void:
	Settings.file.get_or_add("mods_keyboard", {})
	Settings.file.get_or_add("mods_controller", {})
	refresh_inputs()

func refresh_inputs() -> void:
	for action_name: String in keys_to_add:
		if (keys_to_add[action_name].get("player_ids", -1) != -1):
			for i in keys_to_add[action_name]["player_ids"]:
				InputMap.add_action(action_name + "_%s" % i , keys_to_add[action_name].get("deadzone", 0.2))
		else:
			InputMap.add_action(action_name, keys_to_add[action_name].get("deadzone", 0.2))
		
		Settings.file.mods_keyboard[action_name] = keys_to_add[action_name]["keyboard"]
		Settings.file.mods_controller[action_name] = keys_to_add[action_name]["controller"]
		
		var default_kb: Array = keys_to_add[action_name].get("keyboard", [null, null])
		var default_ct: Array = keys_to_add[action_name].get("controller", [null, null])
		
		while default_kb.size() < 2:
			default_kb.append(null)
		while default_ct.size() < 2:
			default_ct.append(null)
		
		if (keys_to_add[action_name].get("player_ids", -1) != -1):
			for i in keys_to_add[action_name]["player_ids"]:
				InputMap.action_add_event(
					action_name + "_%s" % i, bind_value_to_event(default_kb[0], 0))
				InputMap.action_add_event(
					action_name + "_%s" % i, bind_value_to_event(default_kb[1], 0))
				InputMap.action_add_event(
					action_name + "_%s" % i, bind_value_to_event(default_ct[0], 1))
				InputMap.action_add_event(
					action_name + "_%s" % i, bind_value_to_event(default_ct[1], 1))
		else:
			InputMap.action_add_event(
					action_name, bind_value_to_event(default_kb[0], 0))
			InputMap.action_add_event(
				action_name, bind_value_to_event(default_kb[1], 0))
			InputMap.action_add_event(
				action_name, bind_value_to_event(default_ct[0], 1))
			InputMap.action_add_event(
				action_name, bind_value_to_event(default_ct[1], 1))

func bind_value_to_event(value, type := 0) -> InputEvent:
	var event: InputEvent = null
	if value == null:
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
	
	return event
