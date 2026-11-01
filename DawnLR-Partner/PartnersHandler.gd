extends Node

var leader: Player
var partners: Array[Player]

var enemy_leader: Player
var enemies: Array[Player]

var stand_alones: Array[Player]

const PARTNER = preload("res://Scenes/Prefabs/Entities/Player.tscn")
const PLAYER_CONVERTER = preload("res://mods-unpacked/DawnLR-Partner/PlayerConverter.gd")

@onready var saved_characters = Global.player_characters

var INPUT_MEMORY_LENGTH := 0

enum FollowStyle {
	CPU, COPY
}

enum FollowBehavior {
	NORMAL, ENEMY,
	AGRESSIVE, GREEDY, 
	FREE
}

func _enter_tree() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	name = "PartnersHandler"
	
	var new_meta = Global.get_meta("SubGlobals", {})
	new_meta["Partners"] = self
	Global.set_meta("SubGlobals", new_meta)

func start_game(new_leader: Player) -> void:
	_clean_up()
	
	saved_characters = Global.player_characters
	
	INPUT_MEMORY_LENGTH = 120 * Global.player_characters.size() 
	if (Settings.file.partners.follow_mode == 1 && Settings.file.partners.behavior.has(1)):
		INPUT_MEMORY_LENGTH = (320 * Settings.file.partners.behavior.count(1)) * 1 + int(Settings.file.partners.enemy_spawn_delay)
	
	if (new_leader == null):
		Global.log_error("Couldn't create partners. Leader is somehow unset. Report!")
	
	leader = new_leader
	partners.append(leader)
	
	_spawn_partners()

func _clean_up() -> void:
	leader = null
	enemy_leader = null
	
	partners.clear()
	enemies.clear()
	stand_alones.clear()
	
	Global.player_characters = saved_characters

func _spawn_partners() -> void:
	var follow_style = Settings.file.partners.follow_mode as FollowStyle
	var behaviors_id = Settings.file.partners.behavior.duplicate()
	
	var players_in_game = Global.player_characters.duplicate()
	
	players_in_game.remove_at(0) # Because it's the player.
	behaviors_id.remove_at(0) # Idk why I made it like that but it is what it is.
	while players_in_game.find(-1) != -1:
		var not_playing = players_in_game.find(-1)
		
		players_in_game.remove_at(not_playing)
		behaviors_id.remove_at(not_playing)
	
	for i in players_in_game.size():
		_add_partner(i, behaviors_id[i])
		
	_inform_groups_to_players()

func _add_partner(player_id: int, behavior: FollowBehavior) -> void:
	var new_partner: Player = PARTNER.instantiate()
	
	var player_converter: Node = PLAYER_CONVERTER.new()
	player_converter.player = new_partner
	new_partner.add_child(player_converter)
	new_partner.player_id = player_id + 1
	leader.get_parent().add_child.call_deferred(new_partner)
	
	_register_partner(new_partner, behavior)
	
func _register_partner(new_player: Player, behavior: FollowBehavior) -> void:
	match(behavior):
		FollowBehavior.ENEMY:
			new_player.set_meta("delay_id", enemies.size())
			new_player.set_meta("behavior", behavior)
			if (enemies.is_empty()):
				enemy_leader = new_player
			enemies.append(new_player)
			
			new_player.global_position = enemy_leader.global_position
		FollowBehavior.FREE:
			new_player.set_meta("behavior", behavior)
			
			stand_alones.append(new_player)
			
			new_player.global_position = leader.global_position
		_:
			new_player.set_meta("delay_id", partners.size())
			new_player.set_meta("behavior", behavior)
			
			partners.append(new_player)
			
			new_player.global_position = leader.global_position

func _inform_groups_to_players() -> void:
	for i in partners:
		i.set_meta("group", partners)
	for i in enemies:
		i.set_meta("group", enemies)
