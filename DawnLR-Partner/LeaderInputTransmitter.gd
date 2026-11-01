extends Node

var PartnersHandler: Node = Global.get_meta("SubGlobals")["Partners"]

var input_enum: Dictionary = Global.get_meta("InputEnum")
const ACTIONS_DEFAULT := [0, 0, 0, 0, 0]

func reset() -> void:
	actions = ACTIONS_DEFAULT.duplicate()

# Global Position, Velocity
var values := []
var values_memory := []

var actions := ACTIONS_DEFAULT.duplicate()
var actions_memory = []

var memory_position := 0

var mode := "cpu"

func _init() -> void:
	name = "InputTransmitter"

@onready var player: Player = get_parent()

func _ready() -> void:
	for _i in range(PartnersHandler.INPUT_MEMORY_LENGTH):
		actions_memory.append(actions.duplicate())

func _process(delta: float) -> void:
	actions_memory[memory_position] = actions.duplicate()
	match (mode):
		"copy":
			values_memory[memory_position] = values.duplicate()
	
	memory_position += 1
	memory_position = memory_position % PartnersHandler.INPUT_MEMORY_LENGTH

func _physics_process(delta: float) -> void:
	var player_id = player.player_id
	
	var input_actions := ["x", "y", "jump", "action", "run"]
	var methods := ["player_action_pressed", "player_action_just_pressed", "player_action_just_released"]
	
	reset()
	
	for i in methods.size():
		var method: String = methods[i]
		for j in input_actions.size():
			var action: String = input_actions[j]
			var active: int
			
			match (action):
				"x":
					var x_dir := ["move_right", "move_left"]
					active = int(Global.callv(method, [x_dir[0], player_id])) - int(Global.callv(method, [x_dir[1], player_id]))
				"y":
					var y_dir := ["move_down", "move_up"]
					active = int(Global.callv(method, [y_dir[0], player_id])) - int(Global.callv(method, [y_dir[1], player_id]))
				_:
					active = int(Global.callv(method, [action, player_id]))
			
			if (absi(actions[j]) < absi(active * (i + 1))):
				actions[j] = active * (i + 1)
	
	if (actions.find(1) != -1 || actions.find(2) != -1 || actions.find(3) != -1):
		print(actions)
	if (actions.find(-1) != -1 || actions.find(-2) != -1 || actions.find(-3) != -1):
		print(actions)
