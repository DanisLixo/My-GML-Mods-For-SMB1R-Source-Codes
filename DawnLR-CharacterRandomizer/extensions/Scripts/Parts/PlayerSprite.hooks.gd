extends Object

func update(c: ModLoaderHookChain) -> void:
	c.execute_next()
	
	if c.reference_object.resource_setter != null:
		apply_character_sprite_scale(c, c.reference_object.character)

func apply_character_sprite_scale(c: ModLoaderHookChain, character = "") -> void:
	var path = "res://Assets/Sprites/Players/" + character + "/CharacterInfo.json"
	if (FileAccess.open(path, FileAccess.READ) == null):
		path = path.replace("res://Assets/Sprites/Players", Global.config_path.path_join("custom_characters/"))
	path = ResourceSetter.get_pure_resource_path(path)
	var json: Dictionary = JSON.parse_string(FileAccess.open(path, FileAccess.READ).get_as_text())
	
	c.reference_object.scale = Vector2(1, 1)
	
	if (json.get("sprite") == null):
		return
	for i in json.sprite:
		if (i == "scale_multiplier-vector2"):
			var toVector = Vector2(json.sprite[i][0], json.sprite[i][1])
			i = "scale_multiplier"
			c.reference_object.set("scale", c.reference_object.scale * toVector)
