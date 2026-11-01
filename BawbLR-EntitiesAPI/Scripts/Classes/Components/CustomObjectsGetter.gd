extends Node

static var OBJECTS_ZIP_FOLDER = ""
static var OBJECTS_VIRTUAL_FOLDER = "res://custom_objects-unpacked"
const OBJECT_INFO := "ObjectInfo.json"

var JSON_EXAMPLE := {
	"scene": "",
	"offset": [0, 0],
	"is_in_group": false,
	"unlisted": false,
	
	"properties": {
		"name" : "",
		"description" : "",
		"type" : "tile",
		"icon": {
			"texture": "",
			"region_override": [0, 0, 0, 0]
		},
		"secondary_icon": {
			"texture": "",
			"region_override": [0, 0, 0, 0]
		}
	},
	"tile": {
		"source_id": 0,
		"terrain_id": 0,
		"tile_coords": 0,
		"flip_h": 0,
		"flip_v": 0
	},
	"metadata": {}
}

const base64_charset := "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
const tileSelectorScene := preload("res://Scenes/Prefabs/Editor/EditorTileSelector.tscn")
const tileScrollerScene := preload("res://mods-unpacked/BawbLR-EntitiesAPI/Scenes/Prefabs/Editor/EditorSelectorScroller.tscn")

var selectors := []
var remaining_selectors := []
var groups := []

static var customs := []
static var groups_info := []
static var loaded_names := []
static var loaded_groups := []

func set_zips_folder() -> void:
	OBJECTS_ZIP_FOLDER = Global.config_path.path_join("custom_objects")
	
	if (!DirAccess.dir_exists_absolute(OBJECTS_ZIP_FOLDER)):
		DirAccess.make_dir_recursive_absolute(OBJECTS_ZIP_FOLDER)

func find_objects() -> void:
	# Get objects zip files folder and creates one if needed
	set_zips_folder()
	
	# Get the zips themselves, or their folders if they're already installed.
	var object_paths := _ModLoaderPath.get_dir_paths_in_dir(OBJECTS_VIRTUAL_FOLDER)
	if !OS.has_feature("editor"):
		object_paths = _ModLoaderPath.get_zip_paths_in(OBJECTS_ZIP_FOLDER)
	else:
		object_paths.append_array(_ModLoaderPath.get_zip_paths_in(OBJECTS_ZIP_FOLDER))
	
	# Gets the grouped ones, inside the folders inside the main folder.
	var grouped_objects := []
	for i in DirAccess.get_directories_at(OBJECTS_ZIP_FOLDER):
		if loaded_groups.has(i):
			continue
		
		# Gets zips inside the folder
		grouped_objects.append_array(_ModLoaderPath.get_zip_paths_in(OBJECTS_ZIP_FOLDER.path_join(i)))
		
		# Sets the group order, using the file with the order if needed
		var json := {"GroupOrder": Array(DirAccess.get_files_at(OBJECTS_ZIP_FOLDER.path_join(i)))}
		for idx in json["GroupOrder"].size():
			json["GroupOrder"][idx] = json["GroupOrder"][idx].get_basename()
		var group_file := OBJECTS_ZIP_FOLDER.path_join(i).path_join("GroupOrder.json")
		if (FileAccess.file_exists(group_file)):
			json = JSONParser.parse_to_dict(group_file)
		
		# Register the group
		loaded_groups.append(i)
		groups_info.append([i, json])
	object_paths.append_array(grouped_objects)
	
	# Finally, install the objects into the game.
	var warning_mods := []
	for object_path in object_paths:
		# Gets the object's name
		var object_name = object_path.get_basename().split("/")[-1]
		if loaded_names.has(object_name):
			continue
		
		# Install the object
		if (object_path.get_extension() == "zip"):
			var is_mod_loaded_successfully := ProjectSettings.load_resource_pack(object_path)
			if not is_mod_loaded_successfully:
				Global.log_error("Failed to load custom object from path \"%s\". It can somehow be corrupted." % object_path)
				continue
		
		# Gets the object's info
		var object_info: Dictionary = get_object_info(object_path)
		if object_info == null || object_info.is_empty(): continue
		var json := JSON_EXAMPLE.duplicate_deep()
		Global.merge_dict(json, object_info)
		if json["scene"] == null:
			Global.log_error("Failed to load custom object from path \"%s\". No scene got set for it to work." % object_path)
			continue
		
		# List the object so it doesn't gets re-read
		loaded_names.push_back(object_name)
		customs.append([object_name, OBJECTS_VIRTUAL_FOLDER.path_join(object_name), json])
		print("Object \"%s\" got installed: %s" % [object_name, str(DirAccess.get_files_at(OBJECTS_VIRTUAL_FOLDER.path_join(object_name)))])
		
		# Check if object related to a mod
		for i in json.keys():
			var possible_str = json[i]
			
			if (possible_str is String):
				if (possible_str.contains("mods-unpacked")):
					var mod = Array(possible_str.split("/"))
					
					mod = mod[mod.find("mods-unpacked") + 1]
					
					if !warning_mods.has(mod):
						Global.log_warning("There are Custom Objects that uses a GML mod! Make sure to have \"%s\" is installed!" % mod)
						warning_mods.push_back(mod)

func instantiate_selectors() -> void:
	# Clear the freed selectors.
	selectors.clear()
	groups.clear()
	
	print(str(groups_info))
	# Instantiates the groups for the selectors
	for group in groups_info:
		var tileScroller: EditorSelectorScroller
		
		tileScroller = tileScrollerScene.instantiate()
		tileScroller.name = group[0]
		tileScroller.set_meta("group_order", group[1]["GroupOrder"])
		
		groups.append(tileScroller)
	
	# Instantiates the selectors based on the objects
	for object in customs:
		if (object[2].get("unlisted", false)):
			continue
		
		var selector := create_tile_selector(object[0], object[1], object[2])
		
		if (!selector.is_empty()):
			selectors.append(selector)
			
			var fullTab := Global.level_editor.get_node("TileMenu/MarginContainer/VBoxContainer/PanelContainer/TILES/ScrollContainer/VBoxContainer/Custom")
			var objectsLabel := fullTab.get_node("MarginContainer/VBoxContainer/Label")
			objectsLabel.hide()
	
	remaining_selectors = selectors.duplicate(true)
	
	# Add the groups and selectors.
	if (!groups.is_empty() && !remaining_selectors.is_empty()):
		add_selectors()

func create_tile_selector(obj_name: String, objPath: String = "", json: Dictionary = JSON_EXAMPLE) -> Array:
	# Custom object recognition
	var tileSelect: EditorTileSelector = tileSelectorScene.instantiate()
	tileSelect.set_meta("is_mod", true)
	tileSelect.set_meta("mod_path", objPath)
	
	# Loads the object's scene
	if (json["scene"].contains("res://")):
		tileSelect.set_meta("scene_path", json["scene"])
	else:
		tileSelect.set_meta("scene_path", objPath.path_join(json["scene"]))
	tileSelect.entity_scene = load(tileSelect.get_meta("scene_path"))
	if (tileSelect.entity_scene == null):
		Global.log_error("Scene for custom object \"%s\" not found." % json.properties["name"])
		return []
	
	# Sets general info
	tileSelect.name = obj_name
	
	tileSelect.tile_offset = Vector2i(json["offset"][0], 8 + json["offset"][1]) 
	tileSelect.tile_name = json.properties["name"]
	tileSelect.tile_desc = json.properties["description"]
	var type := 0
	match (json.properties["type"].to_lower()):
		"entity": type = 1
		"terrain": type = 2
	tileSelect.type = type
	
	# Sets main icon
	if (json.properties.icon["texture"].contains("res://")):
		tileSelect.icon_texture_path = json.properties.icon["texture"]
	else:
		tileSelect.icon_texture_path = objPath.path_join(json.properties.icon["texture"])
	var rect = json.properties.icon["region_override"]
	tileSelect.icon_region_override = Rect2(rect[0], rect[1], rect[2], rect[3])
	
	# Sets detail icon
	if (json.properties.secondary_icon["texture"].contains("res://")):
		tileSelect.secondary_icon_texture_path = json.properties.secondary_icon["texture"]
	else:
		tileSelect.secondary_icon_texture_path = objPath.path_join(json.properties.secondary_icon["texture"])
	var rect2 = json.properties.secondary_icon["region_override"]
	tileSelect.secondary_icon_region_override = Rect2(rect2[0], rect2[1], rect2[2], rect2[3])
	
	# Sets Tile info (not actually needed lmao)
	for i in json["tile"].keys():
		if (json["tile"][i] is Array):
			var converted := Vector2i(json["tile"][i][0], json["tile"][i][1])
			json.tile[i] = converted
		tileSelect.set(i, json.tile[i])
	
	# Sets allowed actions with selector, in form of metadata.
	for i in json["metadata"].keys():
		tileSelect.set_meta(i, json.metadata[i])
	
	# Adds the object to the selector as the ID the level already has it.
	if (LevelEditor.level_file.has("Mods")):
		for id in LevelEditor.level_file["Mods"]:
			if LevelEditor.level_file["Mods"][id][0] == tileSelect.get_meta("scene_path"):
				tileSelect.entity_id = id
	
	var array := [tileSelect]
	array.append_array(find_my_group(obj_name))
	return array

func add_selectors() -> void:
	var fullTab := Global.level_editor.get_node("TileMenu/MarginContainer/VBoxContainer/PanelContainer/TILES/ScrollContainer/VBoxContainer/Custom")
	var Customs := fullTab.get_node("MarginContainer/VBoxContainer/Customs")
	
	# Adds the groups
	for scroll: EditorSelectorScroller in groups:
		var order: Array = scroll.get_meta("group_order", [])
		
		# For each group, find their respective objects.
		var saved_sels := remaining_selectors.duplicate(true)
		for i in saved_sels:
			var sel_node: EditorTileSelector = i[0]
			var object_name: String = sel_node.name
			var obj_idx := order.find(object_name)
			
			# If found, erase it so it's not counted in the future
			# incase there's more objects with the same name 
			if (obj_idx != -1):
				order[obj_idx] = sel_node
				remaining_selectors.erase(i)
		
		scroll.set_meta("group_order", order)
		# Group sorted, we can finally add them to the scroller
		for i in order:
			if (i is not String):
				scroll.add_child(i)
	
	# Adds the groups. Because of a bug, it's necessary to manually start the scrollers.
	for scroll: EditorSelectorScroller in groups:
		Customs.add_child(scroll)
		
		var order: Array = scroll.get_meta("group_order", [])
		# Group sorted, we can finally add them to the scroller
		for sel_node in order:
			if (sel_node is not String):
				scroll.add_child(sel_node)
				
				sel_node.add_to_group("Selectors")
				sel_node.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
				sel_node.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		
		scroll.selectors.clear()
		scroll._ready()
		
	# Adds the objects
	for sel in remaining_selectors:
		var sel_node: EditorTileSelector = sel[0]
		
		Customs.add_child(sel_node)
		
		sel_node.add_to_group("Selectors")
		sel_node.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		sel_node.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	
	# I don't need them anymore so like.
	remaining_selectors.clear()
	groups.clear()

func find_my_group(object_name: String) -> Array:
	var obj_idx := -1
	var my_group_name := ""
	
	# Find the object ID inside its group, if it has one
	var group_idx := 0
	for group in groups_info:
		obj_idx = group[1]["GroupOrder"].find(object_name)
		if (obj_idx != -1):
			break
		else:
			group_idx += 1
	# Find the group name, if it has one
	if (obj_idx != -1):
		my_group_name = groups_info[group_idx][0]
	
	return [my_group_name, obj_idx]

func get_object_info(object_path: String) -> Dictionary:
	var is_zip = object_path.get_extension() == "zip"
	if is_zip:
		return _ModLoaderFile.get_json_as_dict_from_zip(object_path, OBJECT_INFO)
	else:
		return JSONParser.parse_to_dict(object_path.path_join(OBJECT_INFO))

func set_local_custom_id(selector: EditorTileSelector) -> void:
	var objInfoPath = selector.get_meta("mod_path").path_join("ObjectInfo.json")
	var file: Dictionary = JSON.parse_string(FileAccess.open(objInfoPath, FileAccess.READ).get_as_text())
	var mod_scene = selector.get_meta("mod_path").path_join(file["scene"])
	
	if !LevelEditor.level_file.has("Mods"):
		LevelEditor.level_file["Mods"] = {}
	
	for i in LevelEditor.level_file["Mods"]:
		if LevelEditor.level_file["Mods"][i][0] == mod_scene:
			return
	
	var new_id = "AA"
	while EntityIDMapper.map.has(new_id) or LevelEditor.level_file["Mods"].has(new_id):
		new_id = encode_to_base64_2char(randi_range(0, 4096))
	selector.entity_id = new_id
	
	LevelEditor.level_file["Mods"][new_id] = [selector.get_meta("scene_path"), str(selector.tile_offset.x) + "," + str(selector.tile_offset.y)]
	
	merge_customs_to_map()

func merge_customs_to_map() -> void:
	for sel in selectors:
		var selector: EditorTileSelector = sel[0]
		EntityIDMapper.map[selector.entity_id] = [selector.get_meta("scene_path"), str(selector.tile_offset.x) + "," + str(selector.tile_offset.y)]

func encode_to_base64_2char(value: int) -> String:
	if value < 0 or value >= 4096:
		push_error("Value out of range for 2-char base64 encoding.")
		return ""

	var char1 = base64_charset[(value >> 6) & 0b111111]  # Top 6 bits
	var char2 = base64_charset[value & 0b111111]         # Bottom 6 bits

	return char1 + char2
