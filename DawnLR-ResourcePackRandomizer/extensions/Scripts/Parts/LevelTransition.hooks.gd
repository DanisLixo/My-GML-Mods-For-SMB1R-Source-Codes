extends Object

func _ready(chain: ModLoaderHookChain) -> void:
	if (Global.get_meta("savedList", ["nMQt5f"])[0] == "nMQt5f"):
		Global.set_meta("savedList", Settings.file.visuals.resource_packs.duplicate())
	
	randomize_resource_pack_load()
	Global.level_theme_changed.emit()
	
	chain.execute_next_async()
	
func randomize_resource_pack_load() -> void:
	var savedList = Global.get_meta("savedList", ["nMQtf"])
	if (savedList.size() <= 1):
		return
	
	var newFirstPriority := "**Character**"
	while (newFirstPriority == "**Character**" || newFirstPriority == "BaseAssets"):
		newFirstPriority = savedList.pick_random()
	
	Settings.file.visuals.resource_packs.clear()
	Settings.file.visuals.resource_packs.push_front("BaseAssets")
	Settings.file.visuals.resource_packs.push_front(newFirstPriority)
