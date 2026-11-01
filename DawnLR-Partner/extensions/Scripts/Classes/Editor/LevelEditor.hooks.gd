extends Object

var friendogButtonScene := preload("res://mods-unpacked/DawnLR-Partner/Modded/Friendog/Scenes/CallFriendog.tscn")
var friendogLayerScene := preload("res://mods-unpacked/DawnLR-Partner/Modded/Friendog/Scenes/FriendogLayer.tscn")
var friendogWarningScene := preload("res://mods-unpacked/DawnLR-Partner/Modded/Friendog/Scenes/FriendogWarning.tscn")

func _ready(c: ModLoaderHookChain) -> void:
	var editor: LevelEditor = c.reference_object
	editor.get_node("Info").layer = 2
	
	_add_friendog_warning(editor)
	
	c.execute_next_async()

func _add_friendog_layer(editor: LevelEditor) -> void:
	var toolsBar: HBoxContainer = editor.get_node("CanvasLayer/Tools/MarginContainer/HBoxContainer/TheRest")
	
	var friendogLayer: CanvasLayer = friendogLayerScene.instantiate()
	friendogLayer.editor = editor
	editor.add_child(friendogLayer)
	
	var friendogButton: Button = friendogButtonScene.instantiate()
	friendogButton.mouse_entered.connect(editor.set_toolbar_tooltip.bind("Call Friendog!"))
	friendogButton.mouse_exited.connect(editor.clear_toolbar_tooltip.bind("Call Friendog!"))
	friendogButton.pressed.connect(friendogLayer.set_friendog)
	toolsBar.add_child(friendogButton)
	toolsBar.move_child(friendogButton, toolsBar.get_children().size() - 2)

func _add_friendog_warning(editor: LevelEditor) -> void:
	var toolsBar: HBoxContainer = editor.get_node("CanvasLayer/Tools/MarginContainer/HBoxContainer/TheRest")
	
	var friendogWarning: Control = friendogWarningScene.instantiate()
	editor.get_node("Info").add_child(friendogWarning)
	
	var friendogButton: Button = friendogButtonScene.instantiate()
	friendogButton.mouse_entered.connect(editor.set_toolbar_tooltip.bind("Call Friendog!"))
	friendogButton.mouse_exited.connect(editor.clear_toolbar_tooltip.bind("Call Friendog!"))
	friendogButton.pressed.connect(friendogWarning.open)
	toolsBar.add_child(friendogButton)
	toolsBar.move_child(friendogButton, toolsBar.get_children().size() - 2)
