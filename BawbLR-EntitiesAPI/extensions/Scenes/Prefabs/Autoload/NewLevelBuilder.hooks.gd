extends Object

var error_list := []
var printing := false

func load_level(c: ModLoaderHookChain, temp_level_file := {}) -> void:
	NewLevelBuilder.building = true
	
	if (temp_level_file.has("Mods")):
		NewLevelBuilder.set_meta("custom_list", temp_level_file["Mods"]) 
	EntityIDMapper.load_entity_map()
	
	c.execute_next([temp_level_file])
	
	printing = true
	warning_and_stuff()

func add_entities(c: ModLoaderHookChain, level: Node, chunk := "", chunk_id := 0, layer := 0) -> void:
	var customList = NewLevelBuilder.get_meta("custom_list", {})
	
	var new_chunk := chunk
	for entity in chunk.split("=", false):
		var entity_id = entity.get_slice(",", 1)
		var entity_chunk_position = entity.get_slice(",", 0)
		
		if entity_id == "//" || EntityIDMapper.map.has(entity_id) && customList.has(entity_id):
			var scene = EntityIDMapper.map[entity_id][0]
			
			if entity_id == "//":
				scene = EntityIDMapper.map[entity.get_slice(",", 2)][0]
				if (FileAccess.file_exists(scene)):
					var new_entity = entity.replace(entity, restore_entity(entity))
					new_chunk = new_chunk.replacen(entity, new_entity)
				
				continue
			
			if (!FileAccess.file_exists(scene)):
				var name = customList[entity_id][0].split("/")[3]
				var sceneName = scene.get_file().get_basename()
				
				var add_to_list := true
				for i in error_list:
					if (i[0] == sceneName):
						add_to_list = false
						break
				if (add_to_list):
					error_list.push_back([name, sceneName])
				
				var Fallback = load("res://mods-unpacked/BawbLR-EntitiesAPI/FallBackObject/SaveToExposer.gd").new()
				var properties = Fallback.get_string(
					{"original_id": entity_id, 
					"original_info": entity})
				new_chunk = new_chunk.replacen(entity, entity_chunk_position + ",//" + properties)
			
	c.execute_next([level, new_chunk, chunk_id, layer])

func warning_and_stuff() -> void:
	if (!printing): return
	
	for i in error_list:
		var name = i[0]
		var scene = i[1]
		
		Global.log_error("MISSING CUSTOM OBJECT! 
		REFERENCE: " + name + "\nSCENE: " + scene)
		await Global.get_tree().create_timer(10.0, false).timeout
	
	printing = false
	error_list.clear()

func restore_entity(placeholder_entity := "") -> String:
	var string := placeholder_entity
	
	var old_entity = Array(placeholder_entity.split(","))[-1].replace("&", ",")
	if (old_entity == ""):
		old_entity = placeholder_entity
	
	string = string.replace(placeholder_entity, old_entity)
	
	return string
