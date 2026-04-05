extends Object

var friendogButtonScene := preload("res://mods-unpacked/DawnLR-Partner/Scenes/UI/CallFriendog.tscn")
var friendogLayerScene := preload("res://mods-unpacked/DawnLR-Partner/Scenes/UI/FriendogLayer.tscn")

func _ready(c: ModLoaderHookChain) -> void:
	var editor: LevelEditor = c.reference_object
	var toolsBar: HBoxContainer = editor.get_node("CanvasLayer/Tools/MarginContainer/HBoxContainer/TheRest")
	
	editor.get_node("Info").layer = 2
	
	var friendogLayer: CanvasLayer = friendogLayerScene.instantiate()
	friendogLayer.editor = editor
	
	var friendogButton: Button = friendogButtonScene.instantiate()
	friendogButton.mouse_entered.connect(editor.set_toolbar_tooltip.bind("Call Friendog!"))
	friendogButton.mouse_exited.connect(editor.clear_toolbar_tooltip.bind("Call Friendog!"))
	friendogButton.pressed.connect(friendogLayer.set_friendog)
	toolsBar.add_child(friendogButton)
	toolsBar.move_child(friendogButton, toolsBar.get_children().size() - 2)
	
	
	c.execute_next_async()
