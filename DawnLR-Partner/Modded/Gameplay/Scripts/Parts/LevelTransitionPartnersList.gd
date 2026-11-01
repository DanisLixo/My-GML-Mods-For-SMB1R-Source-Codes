extends Control

func _ready() -> void:
	%Partners.hide()
	%Enemies.hide()
	
	create_list()

func create_list() -> void:
	print(str(GameHUD.character_icons))
	
	if ([Global.GameMode.MARATHON, Global.GameMode.MARATHON_PRACTICE, Global.GameMode.LEVEL_EDITOR].has(Global.current_game_mode)):
		return
	
	for idx in Global.player_characters.size():
		if (idx == 0): continue
		var player_id: int = Global.player_characters[idx]
		var is_enemy: bool = Settings.file.partners.behavior[idx] == 1
		
		if (player_id == -1): continue
		
		var flow_to_add := %PartnersFlow if (!is_enemy) else %EnemiesFlow
		var label_to_show := %Partners if (!is_enemy) else %Enemies
		
		label_to_show.show()
		
		add_icon(flow_to_add, player_id)

func add_icon(flow_to_add: FlowContainer, player_id := 0) -> void:
	var newIcon := TextureRect.new()
	var resourceSetter := ResourceSetterNew.new()
	
	newIcon.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	newIcon.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	
	resourceSetter.node_to_affect = newIcon
	resourceSetter.property_name = "texture"
	resourceSetter.mode = ResourceSetterNew.ResourceMode.TEXTURE
	
	resourceSetter.json_path = (GameHUD.character_icons[player_id])
	
	flow_to_add.add_child(newIcon)
	newIcon.add_child(resourceSetter)
