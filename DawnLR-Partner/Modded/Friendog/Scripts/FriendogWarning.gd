extends Control

func _ready() -> void:
	await get_tree().process_frame
	
	close()

func close() -> void:
	hide()
	
	Global.level_editor.set_state(LevelEditor.EditorState.IDLE)
	
	set_process(false)

func open() -> void:
	show()
	
	Global.level_editor.set_state(LevelEditor.EditorState.TILE_MENU)
	
	%Button.grab_focus()
	set_process(true)
