extends Object

func _physics_process(c: ModLoaderHookChain, delta: float) -> void:
	c.execute_next([delta])
	if Global.multibind_action_just_pressed("editor_move_player"):
		c.reference_object.apply_character_physics()

func apply_character_physics(c: ModLoaderHookChain) -> void:
	c.execute_next()
	return 
	
	var player: Player = c.reference_object
	
	var json = player.PHYSICS_PARAMETERS
	for power_key in json:
		if (json[power_key] is Dictionary):
			randomize_dict(json[power_key], true, json)
	
	player.physics_dict = json

func randomize_dict(json, default_as_ref = false, full_json := {}) -> void:
	if (default_as_ref):
		for key in full_json["Default"]:
			if (json.has(key)):
				if (json[key] is Dictionary):
					randomize_dict(json[key])
				elif (json[key] is Array):
					continue
					# randomize_arr(json[key])
				else:
					set_random(json, key)
			else:
				if (full_json["Default"][key] is Dictionary):
					randomize_dict(json[key], true, full_json)
				elif (full_json["Default"][key] is Array):
					continue
					# randomize_arr(json[key])
				else:
					set_random(json, key, full_json)
			
		return
	
	for key in json:
		if (json[key] is Dictionary):
			randomize_dict(json[key])
		elif (json[key] is Array):
			continue
			# randomize_arr(json[key])
		else:
			set_random(json, key)

func randomize_arr(array) -> void:
	for i in array.size():
		if (i is Dictionary):
			randomize_dict(array[i])
		elif (i is Array):
			randomize_arr(array[i])
		else:
			set_random(array, i)

func set_random(json, key, full_json := {}) -> void:
	var use_json = json if json.has(key) else full_json["Default"]
	
	if (use_json.has(key)):
		if (use_json[key] is int || use_json[key] is float):
			var random := randf_range(use_json[key] * 0.5, use_json[key] * 2.0)
			use_json[key] = random
		elif (use_json[key] is bool):
			var random = bool(randi_range(0, 1))
			use_json[key] = random
