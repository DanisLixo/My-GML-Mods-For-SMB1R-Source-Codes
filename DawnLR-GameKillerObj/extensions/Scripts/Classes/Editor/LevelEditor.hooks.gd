extends Object

const scene := preload("res://mods-unpacked/DawnLR-GameKillerObj/GameKiller/GameKillerLE.tscn")
var extraShit := {}

func _ready(c: ModLoaderHookChain):
	c.execute_next_async()
	
	extraShit = JSON.parse_string(FileAccess.open("res://mods-unpacked/DawnLR-GameKillerObj/ExtraEntityIDMap.json", FileAccess.READ).get_as_text())
	c.reference_object.entity_id_map.merge(extraShit, true)
	
	var le = scene.instantiate()
	var s = c.reference_object.get_node("TileMenu/MarginContainer/VBoxContainer/PanelContainer/TILES/ScrollContainer/VBoxContainer/Gizmos/MarginContainer/VBoxContainer/Output")
	le.owner = c.reference_object
	s.add_child(le)
	
