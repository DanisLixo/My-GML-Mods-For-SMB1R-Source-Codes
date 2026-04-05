extends Object

# I don't care, it works, whatever you say does NOT change this fact.
func set_value(c: ModLoaderHookChain, value_name: ="", value: =0) -> void:
	if Settings.file.game.has("characters") && Settings.file.game.characters.size() != 4:
		Settings.file.game.characters.resize(4)
	
	c.execute_next([value_name, value])
