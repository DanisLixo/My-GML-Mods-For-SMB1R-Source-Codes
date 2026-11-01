class_name PlayerBoomerang
extends CharacterBody2D

const CHARACTERS := ["Mario", "Luigi", "Toad", "Toadette"]

var character := "Mario"

var direction := 1
var speed := 110
var reversed = false
var cooldown := 0.0
var return_timer := 0.4

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

var objects := [
	"BuzzyBeetleShell",
	"GreenKoopaShell",
	"RedKoopaShell"
]

var hammerbrohammer_path := "res://Scenes/Prefabs/Entities/Items/Hammer.tscn"

var enemy_scenes := []
var enemy_path := "res://Scenes/Prefabs/Entities/Enemies/"
var object_path := "res://Scenes/Prefabs/Entities/Objects/"

func _init():
	for i in enemies:
		var scene_path = enemy_path + i + ".tscn"
		enemy_scenes.append(scene_path)
		
	for i in objects:
		var scene_path = object_path + i + ".tscn"
		enemy_scenes.append(scene_path)

func _physics_process(delta: float) -> void:
	print(return_timer)
	return_timer -= delta
	if return_timer <= 0:
		reversed = true
		if (direction == 1 and velocity.x > -200) or (direction == -1 and velocity.x < 200):
			velocity.x -= 10 * direction
	
	velocity.y = 0
	move_and_slide()
	
	if cooldown <= 0:
		for i in $Hitbox.get_overlapping_areas():
			var checking_enemy = i.owner
			if checking_enemy is Player and reversed:
				queue_free()
				break
			if checking_enemy is not Enemy and checking_enemy is not Shell:
				checking_enemy = checking_enemy.owner
			if checking_enemy is Enemy or checking_enemy is Shell:
				hit_enemy(checking_enemy)
				continue
			if checking_enemy != null and checking_enemy.is_in_group("Bowser"):
				checking_enemy.fireball_hit()
				cooldown = .1
				continue
			checking_enemy = i.get_parent()
			# This is for podoboos
			if checking_enemy.has_method("die") and checking_enemy is not Player:
				checking_enemy.die()
	else:
		cooldown -= delta

func hit_enemy(checking_enemy):
	if (!enemy_scenes.has(checking_enemy.scene_file_path)
		&& checking_enemy.scene_file_path.contains("custom_objects")):
		enemy_scenes.append(checking_enemy.scene_file_path)
	
	if checking_enemy.scene_file_path == hammerbrohammer_path:
		# The hammer scene is preloaded so we can't actually hook it. The 'gib' needs to be setup here
		var new_gibspawner = GibSpawner.new()
		checking_enemy.add_child(new_gibspawner)
		new_gibspawner.visuals = checking_enemy.get_node("Sprite")
		new_gibspawner.set_owner(checking_enemy) # I don't think you're supposed to do this but it works
		new_gibspawner.summon_gib(1)
		checking_enemy.die_from_object(self)
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
