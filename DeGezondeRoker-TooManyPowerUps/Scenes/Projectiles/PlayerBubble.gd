class_name PlayerBubble
extends CharacterBody2D

const CHARACTERS := ["Mario", "Luigi", "Toad", "Toadette"]
enum STATES {NORMAL, POPPED, HIT_ENEMY, COIN}

var character := "Mario"

var direction := 1
var speed := 110
var oscillation := 0.0
var player_cooldown := 0.0
var state = STATES.NORMAL
var target := Vector2.ZERO
var target_enemy : Enemy = null

var timer := 0.0

var coin = load("res://Scenes/Prefabs/Entities/Items/SpinningCoin.tscn")

# This is not ideal, but I can't think of a better way to filter enemies without modifying all of their scenes.
var enemies := [
	"Goomba",
	"Blooper",
	"BobOmb",
	"Boo",
	"BulletBill",
	"BuzzyBeetle",
	"DryBones",
	"FighterFly",
	"Goombrat",
	"GreenCheepCheep",
	"GreenKoopaParaTroopa",
	"GreenKoopaTroopa",
	"GreenParaKoopaHori",
	"LeapingCheepCheep",
	"Lakitu",
	"HammerBro",
	"LitBobOmb",
	"MontyMole",
	"PiranhaPlant",
	"Podoboo",
	"Pokey",
	"RedCheepCheep",
	"RedKoopaParaTroopa",
	"RedKoopaTroopa",
	"RedPiranhaPlant",
	"RockyWrench",
	"SideStepper",
	"Spike",
	"Thwomp",
	"Spiny",
	"Sigebou"
]

var invincible_enemies := [
	"Boo",
	"Pokey",
	"SideStepper",
	"Thwomp",
	"Spiny",
]

var objects := [
	"BuzzyBeetleShell",
	"GreenKoopaShell",
	"RedKoopaShell"
]

var enemy_scenes := []
var invincible_enemy_scenes := []
var enemy_path := "res://Scenes/Prefabs/Entities/Enemies/"
var object_path := "res://Scenes/Prefabs/Entities/Objects/"

func _init():
	for i in enemies:
		var scene_path = enemy_path + i + ".tscn"
		enemy_scenes.append(scene_path)
		
	for i in objects:
		var scene_path = object_path + i + ".tscn"
		enemy_scenes.append(scene_path)
		
	for i in invincible_enemies:
		var scene_path = enemy_path + i + ".tscn"
		invincible_enemy_scenes.append(scene_path)


func _physics_process(delta: float) -> void:
	if player_cooldown > 0:
		player_cooldown -= delta
	
	match state:
		STATES.NORMAL:
			oscillation += delta * 5
			velocity.y = sin(oscillation) * 20
			
			velocity.x = speed * direction
			if speed > 40:
				speed -= 40 * delta
			move_and_slide()
						
			for area in $Hitbox.get_overlapping_areas():
				var checking_enemy = area.owner
				if checking_enemy is Player and player_cooldown <= 0:
					player_collision(checking_enemy)
				if checking_enemy is not Enemy and checking_enemy is not Shell:
					checking_enemy = checking_enemy.owner
				if checking_enemy is Enemy or checking_enemy is Shell:
					hit_enemy(checking_enemy, area)
					continue
				if checking_enemy != null and checking_enemy.is_in_group("Bowser"):
					checking_enemy.fireball_hit()
					continue
				checking_enemy = area.get_parent()
				# This is for podoboos
				if checking_enemy.has_method("die") and checking_enemy is not Player:
					hit_enemy(checking_enemy, area)
					
		STATES.HIT_ENEMY:
			velocity.x = 0
			velocity.y = 0
			
			if target_enemy == null or target_enemy.is_queued_for_deletion():
				pop_bubble()
				return
			
			for i in $Hitbox.get_overlapping_areas():
				var checking_enemy = i.get_parent()
				if checking_enemy is Player and player_cooldown <= 0:
					player_collision(checking_enemy)
			
			global_position = global_position.move_toward(target, 100 * delta)
			if global_position - target == Vector2.ZERO:
				target_enemy.process_mode = Node.PROCESS_MODE_INHERIT
				kill_enemy()
				$Coin.show()
				state = STATES.COIN
				oscillation = 0
				timer = 2
				
		STATES.POPPED:
			timer -= delta
			if timer <= 0:
				queue_free()
				
		STATES.COIN:
			oscillation += delta * 5
			velocity.y = sin(oscillation) * 10
			velocity.x = cos(oscillation) * 10
			move_and_slide()
			
			for i in $Hitbox.get_overlapping_areas():
				var checking_enemy = i.get_parent()
				if checking_enemy is Player and player_cooldown <= 0:
					player_collision(checking_enemy)
					return
			
			timer -= delta
			if timer <= 0:
				pop_bubble()
				var node = coin.instantiate()
				node.global_position = global_position
				add_sibling(node)
				Global.coins += 1
				DiscoLevel.combo_meter += 10
				Global.score += 200


func pop_bubble():
	$Sprite.play("Pop")
	state = STATES.POPPED
	timer = 0.12
	$Coin.hide()


func player_collision(checking_player):
	if checking_player.velocity.y > 0:
		checking_player.enemy_bounce_off(false, false)

	if target_enemy != null:
		target_enemy.process_mode = Node.PROCESS_MODE_INHERIT
		kill_enemy()
		state = STATES.COIN

	if state == STATES.COIN:
		$Coin.hide()
		var node = coin.instantiate()
		node.global_position = global_position
		add_sibling(node)
		DiscoLevel.combo_meter += 10
		Global.score += 200
		
	pop_bubble()


func hit_enemy(checking_enemy, hitbox):
	print(checking_enemy.scene_file_path)
	print(invincible_enemy_scenes)
	
	if (!enemy_scenes.has(checking_enemy.scene_file_path)
		&& checking_enemy.scene_file_path.contains("custom_objects")):
		enemy_scenes.append(checking_enemy.scene_file_path)
	
	if checking_enemy.scene_file_path in invincible_enemy_scenes:
		pop_bubble()
		return
	if checking_enemy.scene_file_path in enemy_scenes and checking_enemy.process_mode != Node.PROCESS_MODE_DISABLED:
		target_enemy = checking_enemy
		target = hitbox.get_children()[0].global_position # This should look good in 99% of cases
		state = STATES.HIT_ENEMY
		target_enemy.process_mode = Node.PROCESS_MODE_DISABLED


func kill_enemy():
	target_enemy.killed.emit(1, true, 2)
	if target_enemy.get_node_or_null("ScoreNoteSpawner"):
		target_enemy.get_node("ScoreNoteSpawner").spawn_note(200)
	else:
		var new_scorespawner = ScoreNoteSpawner.new()
		target_enemy.add_child(new_scorespawner)
		new_scorespawner.set_owner(target_enemy)
		new_scorespawner.spawn_note(200)
	target_enemy.queue_free()


func hit() -> void:
	pass
