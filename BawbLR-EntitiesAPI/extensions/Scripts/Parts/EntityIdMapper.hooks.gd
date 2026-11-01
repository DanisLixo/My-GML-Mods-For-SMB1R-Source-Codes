extends Object

static var FALLBACK_SCENE_PATH := "res://mods-unpacked/BawbLR-EntitiesAPI/FallBackObject/FallbackObject.tscn"

static func load_entity_map(c:ModLoaderHookChain) -> void:
	c.execute_next()
	
	EntityIDMapper.map["//"] = [FALLBACK_SCENE_PATH, "0,0"]
	
	var cur_scene = NewLevelBuilder
	var modded = !cur_scene.get_meta("custom_list", {}).is_empty()
	if modded:
		c.reference_object.map.merge(cur_scene.get_meta("custom_list", {}))
