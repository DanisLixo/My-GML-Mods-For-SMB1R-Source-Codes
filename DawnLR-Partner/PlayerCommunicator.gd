extends Node

var PartnersHandler: Node = Global.get_meta("SubGlobals")["Partners"]

# lazy, 0 normal, 1 enemy, 2 free
var group_id := 0 

var share_in_progress := false

signal power_up(grabber: Player, power_name: String)
signal power_lost(grabber: Player, type: String)
signal star_up(grabber: Player)
signal wing_up(grabber: Player)
signal hammer_up(grabber: Player)

@onready var player: Player = get_parent()
@onready var group: Array = player.get_meta("group", [])

func _ready() -> void:
	add_to_group("Communicators")
	var behavior = player.get_meta("behavior", PartnersHandler.FollowBehavior.NORMAL)
	
	match (behavior):
		PartnersHandler.FollowBehavior.ENEMY:
			group_id = 1
		PartnersHandler.FollowBehavior.FREE:
			group_id = -1
	
	await get_tree().process_frame
	
	for i in get_tree().get_nodes_in_group("Communicators"):
		i.power_up.connect(_share_power_up)
		i.power_lost.connect(_share_damage)
		i.star_up.connect(_share_star)
		i.wing_up.connect(_share_wing)
		i.hammer_up.connect(_share_hammer)

func _share_power_up(grabber: Player, power_name := "") -> void:
	if (share_in_progress || grabber == player): 
		return
	
	share_in_progress = true
	if (player in group && grabber in group):
		player.get_power_up(power_name)
	
	share_in_progress = false

func _share_damage(grabber: Player, type := "") -> void:
	if (share_in_progress || grabber == player): 
		return
	
	share_in_progress = true
	if (player in group && grabber in group):
		player.damage(type)
	
	share_in_progress = false

func _share_star(grabber: Player) -> void:
	if (share_in_progress || grabber == player): 
		return
	
	share_in_progress = true
	if (player in group && grabber in group):
		player.super_star()
	
	share_in_progress = false

func _share_wing(grabber: Player) -> void:
	if (share_in_progress || grabber == player): 
		return
	
	share_in_progress = true
	if (player in group && grabber in group):
		player.wing_get()
	
	share_in_progress = false

func _share_hammer(grabber: Player) -> void:
	if (share_in_progress || grabber == player): 
		return
	
	share_in_progress = true
	if (player in group && grabber in group):
		player.hammer_get()
	
	share_in_progress = false
