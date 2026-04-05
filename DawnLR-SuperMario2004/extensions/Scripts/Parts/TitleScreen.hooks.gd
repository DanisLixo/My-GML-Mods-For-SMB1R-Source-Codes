extends Object

func _ready(c: ModLoaderHookChain) -> void:
	c.execute_next_async()
	var enviromentDestroyer = load("res://mods-unpacked/DawnLR-SuperMario2004/Scenes/TitleScreenWorld.tscn").instantiate()
	enviromentDestroyer.name = "EnviromentDestroyer2"
	c.reference_object.add_child(enviromentDestroyer)
