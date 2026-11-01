extends Object

# Put the scene of the selection of the tile right here
const ItemScene := preload("res://mods-unpacked/DawnLR-GameKillerObj/GameKiller/GameKillerLE.tscn")

var selectionTab := "TileMenu/MarginContainer/VBoxContainer/PanelContainer/TILES/ScrollContainer/VBoxContainer/Mods/MarginContainer/VBoxContainer"

func _ready(c: ModLoaderHookChain):
	c.execute_next_async()
	
	# var extraShit = JSON.parse_string(FileAccess.open("res://mods-unpacked/DawnLR-GameKillerObj/EntityID.json", FileAccess.READ).get_as_text())
	# c.reference_object.entity_id_map.merge(extraShit, true)
	var item := ItemScene.instantiate()
	var tabb = c.reference_object.get_node(selectionTab)
	tabb.add_child(item)
