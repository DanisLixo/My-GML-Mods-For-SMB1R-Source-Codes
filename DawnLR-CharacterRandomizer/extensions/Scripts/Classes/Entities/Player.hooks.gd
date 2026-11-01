extends Object

func _ready(c: ModLoaderHookChain) -> void:
	c.execute_next()
	
	Settings.get_meta("RandomizerMod").firstLoad = false
