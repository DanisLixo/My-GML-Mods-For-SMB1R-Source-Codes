extends Node

const PARTNER_TRACKING_TOOLS = preload("res://mods-unpacked/DawnLR-Partner/PartnerTrackingTools.tscn")

class nothing extends Node:
	var max_value := 0.0

var player: Player
var PartnersHandler: Node

func _enter_tree() -> void:
	PartnersHandler = Global.get_meta("SubGlobals")["Partners"]
	_setup_partner()

func _setup_partner() -> void:
	player.add_to_group("Players-AI")
	_add_partner_stuff()
	
	var oldID = player.get("player_id")
	
	player.player_id %= 4
	await player.ready
	player.player_id = oldID
	
	_fix_partner_to_settings()

func _spawn_track_tools() -> void:
	var track_tools: Node = PARTNER_TRACKING_TOOLS.instantiate()
	player.add_child(track_tools)

func _add_partner_stuff() -> void:
	var partner_cpu_machine

func _fix_partner_to_settings() -> void:
	var canvas_layer: CanvasLayer = player.get_node_or_null("CanvasLayer")
	
	if (canvas_layer != null):
		canvas_layer.queue_free()
	
	var camera := player.camera
	if (camera != null):
		camera.enabled = false
		
		var camera_handler: CameraHandler = player.get_node_or_null("%CameraHandler")
		
		if (camera_handler != null):
			camera_handler.queue_free()
		
		if (player.camera_center_joint != null):
			player.camera_center_joint.queue_free()
	
	if (player.get_node_or_null("CanvasLayer/Control2/MarginContainer/Timers/StarTimer/TimerSprite") == null):
		var node_path := ["CanvasLayer", "Control2", "MarginContainer", "Timers", "StarTimer", "TimerSprite"]
		var parent_node: Node = player
		for i in node_path.size():
			var node: Node
			if (node_path[i] == node_path.back()):
				node = nothing.new()
			else:
				node = Node.new()
			node.name = node_path[i]
			
			parent_node.add_child(node)
			parent_node = node
	
	#var oldID = Global.player_characters[player_id]
	#
	#match (thingie.PARTNER_PHYSICS):
		#0:
			#character = "Mario"
			#Global.player_characters[player_id] = 0
		#1:
			#character = CHARACTERS[int(Global.player_characters[player_id])]
		#2:
			#character = CHARACTERS[int(Global.player_characters[0])]
			#Global.player_characters[player_id] = Global.player_characters[0]
	#while (Global.player_power_states.length() < player_id + 1):
		#Global.player_power_states += "0"
	##endregion
	#
	#apply_character_physics()
	#
	#Global.player_characters[player_id] = oldID
	#character = CHARACTERS[int(Global.player_characters[player_id])]
	#
	#if Global.current_level.first_load and Global.current_game_mode == Global.GameMode.MARATHON_PRACTICE:
		#Global.player_power_states[player_id] = "0"
	#
	#var cur_power_state = int(Global.player_power_states[player_id])
	#power_state = get_node("PowerStates/" + physics_params("STARTING_POWER_STATE", POWER_PARAMETERS))
	#power_state = $PowerStates.get_node(POWER_STATES[cur_power_state])
