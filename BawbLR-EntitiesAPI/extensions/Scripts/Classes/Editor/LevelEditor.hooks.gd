extends Object

var CustomObjectsGetter: Node

func _ready(c: ModLoaderHookChain) -> void:
	Global.level_editor = c.reference_object
	
	var objs_getter = load("res://mods-unpacked/BawbLR-EntitiesAPI/Scripts/Classes/Components/CustomObjectsGetter.gd").new()
	CustomObjectsGetter = objs_getter
	
	var custom_tab = load("res://mods-unpacked/BawbLR-EntitiesAPI/Scenes/UI/Editor/CustomTab.tscn").instantiate()
	var container: Control = c.reference_object.get_node("TileMenu/MarginContainer/VBoxContainer/PanelContainer/TILES/ScrollContainer/VBoxContainer")
	
	c.reference_object.add_child(CustomObjectsGetter)
	container.add_child(custom_tab)
	
	CustomObjectsGetter.find_objects()
	CustomObjectsGetter.instantiate_selectors()
	
	if (LevelEditor.level_file.has("Mods")):
		NewLevelBuilder.set_meta("custom_list", LevelEditor.level_file["Mods"]) 
	
	c.execute_next_async()
	
	CustomObjectsGetter.merge_customs_to_map()

func on_tile_selected(c: ModLoaderHookChain, selector: EditorTileSelector) -> void:
	if selector.get_meta("is_mod", false):
		CustomObjectsGetter.set_local_custom_id(selector)
	
	c.execute_next([selector])
