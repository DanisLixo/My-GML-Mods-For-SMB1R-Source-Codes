extends Node2D

@onready var PartnerSettings = Settings.get_meta("PartnersMod") 

const burstScene := preload("res://mods-unpacked/DawnLR-Partner/Modded/Gameplay/Scenes/Prefabs/BubbleBurst.tscn")

var thingie: Node
var scaleMultiplier := Vector2.ONE
var enemies: Array = []

@export var icons: Array[Node] = []
@export var scaleAnimation := Vector2.ONE

var spawnTime := 0.0

func _ready() -> void:
	for i in enemies:
		i.hide()
		i.state_machine.transition_to("Freeze")
		i.process_mode = Node.PROCESS_MODE_DISABLED
		
		make_icon_for_enemy(i)
	
	var flagpole: Node2D
	
	for i in get_tree().get_nodes_in_group("Flagpole"):
		if i is Node2D:
			flagpole = i
	
	if flagpole != null:
		flagpole.player_reached.connect(explode_everyone)
	else:
		for i in get_tree().get_nodes_in_group("CastleBridges"):
			if i is Node2D:
				flagpole = i
		if (flagpole != null):
			flagpole.victory_begin.connect(explode_everyone)
	
	$CanvasLayer/Control/HBoxContainer/Control/SpawnTimeSprite.max_value = PartnerSettings.file.selector.enemy_spawn_delay
	$CanvasLayer.visible = false
	await get_tree().create_timer(1).timeout
	$CanvasLayer.visible = true

func _process(delta: float) -> void:
	if (spawnTime > 0.0):
		spawnTime -= delta
	else:
		queue_free()
	
	var floated := snappedf(spawnTime, 0.1)
	$Label.text = str(floated)
	$Bubble.scale = scaleAnimation * scaleMultiplier

func _exit_tree() -> void:
	explode_everyone()
	
	var burst := burstScene.instantiate()
	burst.global_position = global_position
	
	get_tree().current_scene.add_child(burst)
	burst.emitting = true
	
func make_icon_for_enemy(player: Player) -> void:
	var newIcon := Sprite2D.new()
	var resourceSetter := ResourceSetterNew.new()
	
	resourceSetter.node_to_affect = newIcon
	resourceSetter.property_name = "texture"
	resourceSetter.mode = ResourceSetterNew.ResourceMode.TEXTURE
	
	icons.append(newIcon)
	
	resourceSetter.json_path = (GameHUD.character_icons[int(Global.player_characters[player.player_id])])
	
	$Icons.add_child(newIcon)
	newIcon.add_child(resourceSetter)

func explode_everyone() -> void:
	for i in enemies:
		i.show()
		
		i.process_mode = Node.PROCESS_MODE_INHERIT
		
		i.state_machine.transition_to("Normal")
		i.thingie.spawned = true
		i.thingie.damagesPlayer = true
	
	queue_free()

func on_screen() -> void:
	$CanvasLayer/AnimationPlayer.play_backwards("enter")

func off_screen() -> void:
	$CanvasLayer/AnimationPlayer.play("enter")
