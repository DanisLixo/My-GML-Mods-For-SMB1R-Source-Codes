extends Object

var PartnersHandler: Node

var is_leader: bool
var player: Player
var input_handler: Node
var communicator: Node

func _ready(c: ModLoaderHookChain) -> void:
	c.execute_next()
	l_set_essencials(c, false)
	
	if (is_leader):
		PartnersHandler.start_game(player)
		l_setup_leader()
	else:
		l_setup_partner()

func damage(c: ModLoaderHookChain, type: String = "") -> void:
	l_set_essencials(c)
	c.execute_next_async([type])
	
	communicator.power_lost.emit(player, type)

func get_power_up(c: ModLoaderHookChain, power_name := "", give_points := true) -> void:
	l_set_essencials(c)
	c.execute_next_async([power_name, give_points])
	
	communicator.power_up.emit(player, power_name)
	
func super_star(c: ModLoaderHookChain):
	l_set_essencials(c)
	c.execute_next()
	
	communicator.star_up.emit(player)

func wing_get(c: ModLoaderHookChain) -> void:
	l_set_essencials(c)
	c.execute_next()
	
	communicator.wing_up.emit(player)

func hammer_get(c: ModLoaderHookChain) -> void:
	l_set_essencials(c)
	c.execute_next()
	
	communicator.hammer_up.emit(player)

func l_setup_leader() -> void:
	var _input_handler = load("res://mods-unpacked/DawnLR-Partner/LeaderInputTransmitter.gd").new()
	player.add_child(_input_handler)
	player.set_meta("input_handler", _input_handler)
	
	var _communicator = load("res://mods-unpacked/DawnLR-Partner/PlayerCommunicator.gd").new()
	player.add_child(_communicator)
	player.set_meta("communicator", _communicator)

func l_setup_partner() -> void:
	var _input_handler = load("res://mods-unpacked/DawnLR-Partner/PartnerInputReceiver.gd").new()
	player.add_child(_input_handler)
	player.set_meta("input_handler", _input_handler)
	
	var _communicator = load("res://mods-unpacked/DawnLR-Partner/PlayerCommunicator.gd").new()
	player.add_child(_communicator)
	player.set_meta("communicator", _communicator)

func l_set_essencials(chain: ModLoaderHookChain, set_rest: bool = true) -> void:
	player = chain.reference_object
	if (set_rest):
		input_handler = player.get_meta("input_handler")
		communicator = player.get_meta("communicator")
	
	PartnersHandler = Global.get_meta("SubGlobals")["Partners"]
	is_leader = (player.player_id == 0 && Global.get_tree().get_first_node_in_group("Players")) || (player == PartnersHandler.leader)
