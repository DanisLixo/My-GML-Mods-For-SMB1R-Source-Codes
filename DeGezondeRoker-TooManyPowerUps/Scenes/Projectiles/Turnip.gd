class_name Turnip
extends CharacterBody2D

const CHARACTERS := ["Mario", "Luigi", "Toad", "Toadette"]

var character := "Mario"

var speed := 0.0
var direction := 1
const FIREBALL_EXPLOSION = preload("res://mods-unpacked/DeGezondeRoker-TooManyPowerUps/Scenes/TurnipDestructionParticles.tscn")

var enemies := [
	"Goomba",
	"Blooper",
	"BobOmb",
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
	"Pokey",
	"RedCheepCheep",
	"RedKoopaParaTroopa",
	"RedKoopaTroopa",
	"RedPiranhaPlant",
	"RockyWrench",
	"SideStepper",
	"Spike",
	"Spiny",
]

var objects := [
	"BuzzyBeetleShell",
	"GreenKoopaShell",
	"RedKoopaShell"
]

var enemy_scenes := []
var enemy_path := "res://Scenes/Prefabs/Entities/Enemies/"
var object_path := "res://Scenes/Prefabs/Entities/Objects/"

var timer := 1
var bounce_count := 0
var bounce_heights = [-125, -250, -300, -125, -340, -135, -160, -200, -125, -400]
var bounce_flip = [false, false, false, true, false, false, true, false, false, true]

func _init():
	for i in enemies:
		var scene_path = enemy_path + i + ".tscn"
		enemy_scenes.append(scene_path)
		
	for i in objects:
		var scene_path = object_path + i + ".tscn"
		enemy_scenes.append(scene_path)

func _physics_process(delta: float) -> void:
	$Sprite.scale.x = direction
	$Sprite.speed_scale = direction * 1
	velocity.y += (15 / delta) * delta
	velocity.y = clamp(velocity.y, -INF, 600)
	if speed > 100:
		speed -= (1 / delta) * delta
	
	if timer == 0:
		if is_on_wall():
			direction *= -1
			speed -= 20
			
		velocity.x = speed * direction
		
		if is_on_ceiling():
			velocity.y = 20
		
		if is_on_floor():
			velocity.y = bounce_heights[bounce_count]
			if bounce_flip[bounce_count] == true:
				direction *= -1
				speed -= 20
				if speed < 30:
					hit(true)
			bounce_count += 1
			bounce_count %= 10
			
		move_and_slide()
		
		var blocks = get_node_or_null("BlockHitbox").get_overlapping_bodies()
		for i in blocks:
			if i is Block:
				if is_on_wall() or is_on_ceiling() or is_on_floor():
					var shell = Shell.new() # this is dumb
					i.shell_block_hit.emit(shell)
					shell.queue_free()
					return
		
		var areas = get_node_or_null("Hitbox").get_overlapping_areas()
		for i in areas:
			var checking_enemy = i.owner
			if checking_enemy is not Enemy and checking_enemy is not Shell:
				checking_enemy = checking_enemy.owner
			if checking_enemy is Enemy or checking_enemy is Shell:
				hit_enemy(checking_enemy)
				continue
			if checking_enemy != null and checking_enemy.is_in_group("Bowser"):
				checking_enemy.fireball_hit()
				continue
			checking_enemy = i.get_parent()
	else:
		timer -= 1

func hit_enemy(checking_enemy):
	if (!enemy_scenes.has(checking_enemy.scene_file_path)
		&& checking_enemy.scene_file_path.contains("custom_objects")):
		enemy_scenes.append(checking_enemy.scene_file_path)
	
	if checking_enemy.scene_file_path in enemy_scenes:
		if checking_enemy.has_method("die_from_object"):
			checking_enemy.die_from_object(self)
		if checking_enemy.get_node_or_null("ScoreNoteSpawner"):
			checking_enemy.get_node("ScoreNoteSpawner").spawn_note(200)
		else:
			var new_scorespawner = ScoreNoteSpawner.new()
			checking_enemy.add_child(new_scorespawner)
			new_scorespawner.set_owner(checking_enemy)
			new_scorespawner.spawn_note(200)
		hit()
	pass

func hit(play_sfx := true) -> void:
	if play_sfx:
		AudioManager.play_sfx("bump", global_position)
		summon_explosion()
		queue_free()

func summon_explosion() -> void:
	var node = FIREBALL_EXPLOSION.instantiate()
	node.global_position = global_position
	add_sibling(node)
