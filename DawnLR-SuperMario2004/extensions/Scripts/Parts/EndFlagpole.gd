extends "res://Scripts/Parts/EndFlagpole.gd"

func _ready():
	super()
	
	get_tree().get_first_node_in_group("GameDestroyer").levelFlagpole = self

func player_touch(player: Player):
	get_tree().get_first_node_in_group("GameDestroyer").canProgressWorsing = false
	get_tree().get_first_node_in_group("GameDestroyer").start_restore(0.0)
	
	super(player)
