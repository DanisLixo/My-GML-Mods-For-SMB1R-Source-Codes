extends Object

func _ready(c:ModLoaderHookChain):
	var name: String = c.reference_object.get_parent().scene_file_path.get_file().get_basename().to_lower()
	if (name.contains("invisible") && name.contains("questionblock")):
		var editorCue = c.reference_object
		var sprite = c.reference_object.get_parent().get_node("Sprite")
		
		sprite.visibility_changed.connect(
			func(): 
				if (sprite.visible):
					editorCue.hide()
				else:
					editorCue.show()
		)
		return
	c.execute_next()
