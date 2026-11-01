class_name SuperBall
extends CharacterBody2D

const CHARACTERS := ["Mario", "Luigi", "Toad", "Toadette"]

var character := "Mario"

var direction := 1
const FIREBALL_EXPLOSION = preload("res://Scenes/Prefabs/Particles/FireballExplosion.tscn")

const MOVE_SPEED := 220

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

func _init():
	for i in enemies:
		var scene_path = enemy_path + i + ".tscn"
		enemy_scenes.append(scene_path)
		
	for i in objects:
		var scene_path = object_path + i + ".tscn"
		enemy_scenes.append(scene_path)

func _physics_process(_delta: float) -> void:
	if is_on_floor():
		velocity.y = -MOVE_SPEED
	if is_on_ceiling():
		velocity.y = MOVE_SPEED
	if is_on_wall():
		direction *= -1
	velocity.x = MOVE_SPEED * direction
	move_and_slide()
	
	var areas = get_node_or_null("Hitbox").get_overlapping_areas()
	
	for i in areas:
		if i.owner.is_in_group("Coins"):
			if i.owner.get_node_or_null("Sprite") != null: # This is a pretty idiotic way of checking whether the coin has already been collected
				i.owner.collect()
	
	for i in $Hitbox.get_overlapping_areas():
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
		# This is for podoboos
		if checking_enemy.has_method("die") and checking_enemy is not Player:
			checking_enemy.die()


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
