extends Object

func _ready(c: ModLoaderHookChain) -> void:
	var mod = AudioManager.get_node("/root/ModLoader/DawnLR-MovesetPlus")
	AudioManager.sfx_library.merge(mod.MOVESET_PLUS_SFX_LIBRARY)
	
	c.execute_next_async()
