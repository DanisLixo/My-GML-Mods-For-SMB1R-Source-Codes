extends Node2D

var idx := 0
var enemies: Array = []
var thingie: Node

var fullSpawnTime: float
var spawnTime := 0.0

var character := ""
var player_id := 0

func _ready() -> void:
	fullSpawnTime = Settings.file.partners.enemy_spawn_delay
	for i in enemies:
		i.hide()
		i.process_mode = Node.PROCESS_MODE_DISABLED
	
	$CanvasLayer/Control/HBoxContainer/Control/SpawnTimeSprite.max_value = Settings.file.partners.enemy_spawn_delay
	$CanvasLayer.visible = false
	await get_tree().create_timer(1).timeout
	$CanvasLayer.visible = true

func _process(delta: float) -> void:
	if (spawnTime > 0.0):
		spawnTime -= delta
	else:
		handle_spawn()
	var floated := snappedf(spawnTime, 0.1)
	$Label.text = str(floated)

func handle_spawn() -> void:
	var enemy = enemies[idx]
	enemy.show()
	
	enemy.process_mode = Node.PROCESS_MODE_INHERIT
	
	enemy.thingie.memoryPosition = 0
	enemy.thingie.spawned = true
	enemy.thingie.damagesPlayer = true
	
	idx += 1
	spawnTime = fullSpawnTime
	
	if (idx == enemies.size()): 
		queue_free()
		return

func on_screen() -> void:
	$CanvasLayer/AnimationPlayer.play_backwards("enter")

func off_screen() -> void:
	$CanvasLayer/AnimationPlayer.play("enter")
