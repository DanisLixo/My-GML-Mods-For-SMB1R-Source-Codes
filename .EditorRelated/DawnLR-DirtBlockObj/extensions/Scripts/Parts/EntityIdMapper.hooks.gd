extends Object

var extraShit := {}

func _ready(c: ModLoaderHookChain) -> void:
	c.reference_object.map = JSON.parse_string(FileAccess.open(c.reference_object.MAP_PATH, FileAccess.READ).get_as_text())
	extraShit = JSON.parse_string(FileAccess.open("res://mods-unpacked/DawnLR-GameKillerObj/EntityID.json", FileAccess.READ).get_as_text())
	c.reference_object.map.merge(extraShit, true)
	
	if Engine.is_editor_hint() == false and OS.is_debug_build() and c.reference_object.auto_update:
		c.reference_object.update_map()

func update_map(c: ModLoaderHookChain) -> void:
	c.reference_object.map = JSON.parse_string(FileAccess.open(c.reference_object.MAP_PATH, FileAccess.READ).get_as_text())
	extraShit = JSON.parse_string(FileAccess.open("res://mods-unpacked/DawnLR-GameKillerObj/EntityID.json", FileAccess.READ).get_as_text())
	c.reference_object.map.merge(extraShit, true)
	
	c.reference_object.get_ids()
	c.reference_object.save_to_json()
	print("done")
