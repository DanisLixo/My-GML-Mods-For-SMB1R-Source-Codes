extends Object

## This is a workaround to the scale, remember that fixed_position will be necessary if the scale_multiplier is different than "1.0".
func _ready(c: ModLoaderHookChain):
	var obj: BetterAnimatedSprite2D = c.reference_object
	
	var resource_setter
	for i in obj.get_children():
		if (i is ResourceSetterNew):
			resource_setter = i
	
	obj.set_meta("ResourceSetter", resource_setter)
	
	if (resource_setter != null && !obj.get_meta("Modified", false)):
		get_meta_from_json(obj)
	
	frame_fix_changed(obj)
	
	if (obj.get_meta("scale_multiplier", Vector2.ZERO) == Vector2.ZERO):
		c.execute_next()

func _process(c: ModLoaderHookChain, delta: float):
	var obj: BetterAnimatedSprite2D = c.reference_object
	
	if (obj.get_meta("ResourceSetter", obj) != obj && !obj.get_meta("Modified", false)):
		get_meta_from_json(obj)
	
	frame_fix_changed(obj)
	
	if (obj.get_meta("scale_multiplier", Vector2.ZERO) == Vector2.ZERO):
		c.execute_next([delta])

# This ends up making the game less optimized, any complain will be enough for me to take this off.
func get_meta_from_json(obj: Object) -> void:
	var resource_setter = obj.get_meta("ResourceSetter", obj)
		
	var json: Dictionary
	if (resource_setter is ResourceSetterNew):
		var resource_path = resource_setter.resource_json.resource_path
		var current_resource_pack = ""
		Settings.file.visuals.resource_packs.append("**Character**")
		for i in Settings.file.visuals.resource_packs:
			var new_path = resource_setter.get_resource_pack_path(resource_path, i)
			if resource_path != new_path or current_resource_pack == "":
				current_resource_pack = i
			resource_path = new_path
		Settings.file.visuals.resource_packs.erase("**Character**")
		
		json = JSON.parse_string(FileAccess.open(resource_path, FileAccess.READ).get_as_text())
		
	if (json == null):
		return
	
	if (json.has("properties")):
		for property in json.properties:
			var value = json.properties[property]
			if (value is Array):
				if (str(property).contains("-vector2")):
					value = convert_to_vector(property, json.properties)
					property = property.replace("-vector2", "")
			
			obj.set(property, value)
			obj.set_meta(property, value)
		
	obj.set_meta("Modified", true)

func frame_fix_changed(obj: Object):
	var scale_multiplier = obj.get_meta("scale_multiplier", 0)
	var fixed_position = obj.get_meta("fixed_position", 0)

	if obj.sprite_frames == null: return
	var texture = obj.sprite_frames.get_frame_texture(obj.animation, obj.frame)
	if texture == null: return
	
	if (fixed_position is Vector2):
		obj.process_priority = 1
		obj.position = fixed_position
	if (scale_multiplier is Vector2):
		if (abs(obj.scale.x) == 1):
			obj.scale.x *= scale_multiplier.x
		
		obj.scale.y = scale_multiplier.y

func convert_to_vector(key: Variant, json: Dictionary) -> Vector2:
	return Vector2(float(json[key][0]), float(json[key][1]))
