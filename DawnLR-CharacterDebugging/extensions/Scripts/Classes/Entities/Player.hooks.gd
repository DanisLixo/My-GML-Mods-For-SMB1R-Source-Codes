extends Object

var player: Player
var debugger: Node

func set_essencials(chain: ModLoaderHookChain):
	player = chain.reference_object
	if (player.player_id == 0):
		debugger = player.get_meta("debugger", null)

func _ready(c:ModLoaderHookChain):
	var _player: Player = c.reference_object
	
	c.execute_next()
	if (debugger == null):
		var debugCharacter = load("res://mods-unpacked/DawnLR-CharacterDebugging/Scripts/Parts/AnimationDebug.gd").new()
		debugCharacter.name = "DebugLayer"
		_player.add_child(debugCharacter)
		_player.set_meta("debugger", debugCharacter)
		_player.normal_state.set_meta("debugger", debugCharacter)
		debugger = debugCharacter

func play_animation(c:ModLoaderHookChain, animation_name := "", force := false) -> void:
	set_essencials(c)
	if (debugger != null):
		debugger.playerOverride = animation_name 
	c.execute_next([animation_name, force])

func power_up_animation(c:ModLoaderHookChain, new_power_state := "") -> void:
	set_essencials(c)
	if (debugger != null):
		debugger.playerOverride = "PowerUp"
		debugger.old_power_state = player.power_state.state_name
		debugger.new_power_state = new_power_state
	c.execute_next_async([new_power_state])
	
