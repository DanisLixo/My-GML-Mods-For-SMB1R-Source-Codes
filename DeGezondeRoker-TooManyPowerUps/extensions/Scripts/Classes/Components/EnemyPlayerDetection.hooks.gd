extends Object

var blueshell_enemies := [
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

var blueshell_objects := [
	"BuzzyBeetleShell",
	"GreenKoopaShell",
	"RedKoopaShell"
]

var blueshell_enemies_2 := [
	"Goomba",
	"BobOmb",
	"BuzzyBeetle",
	"DryBones",
	"Goombrat",
	"MontyMole",
	"Spike",
	"Spiny",
	"RedKoopaParaTroopa",
	"RedKoopaTroopa",
	"GreenKoopaParaTroopa",
	"GreenKoopaTroopa"
]

var blueshell_kills := []
var blueshell_turns := []
var enemy_path := "res://Scenes/Prefabs/Entities/Enemies/"
var object_path := "res://Scenes/Prefabs/Entities/Objects/"

func _init():
	for i in blueshell_enemies:
		var scene_path = enemy_path + i + ".tscn"
		blueshell_kills.append(scene_path)
		
	for i in blueshell_objects:
		var scene_path = object_path + i + ".tscn"
		blueshell_kills.append(scene_path)
	
	for i in blueshell_enemies_2:
		var scene_path = enemy_path + i + ".tscn"
		blueshell_turns.append(scene_path)
		
func player_entered(chain: ModLoaderHookChain, player: Player) -> void:
	var refobj = chain.reference_object
	var enemy: Node = refobj.get_parent()
	if enemy is not Enemy:
		enemy = enemy.get_parent().get_parent().get_parent().get_parent()
	print(enemy.scene_file_path)
	if (enemy is Projectile):
		chain.execute_next([player])
		return
	
	if (!blueshell_kills.has(enemy.scene_file_path)
		&& enemy.scene_file_path.contains("custom_objects")):
		blueshell_kills.append(enemy.scene_file_path)
	
	if player.power_state.state_name == "Shell" and enemy.scene_file_path in blueshell_kills:
		if player.crouching or player.power_state.sliding == true:
			if abs(player.velocity.x) > 80:
				if enemy.has_method("die_from_object"):
					enemy.die_from_object(player)
				if refobj.get_parent().get_node_or_null("ScoreNoteSpawner"):
					refobj.get_parent().get_node("ScoreNoteSpawner").spawn_note(200)
				return
			else:
				if ((player.velocity.y >= 15 or (player.global_position.y + refobj.height < enemy.global_position.y)) and player.in_water == false) == false:
					if enemy.scene_file_path in blueshell_turns:
						var can_turn = false
						if enemy.global_position.x > player.global_position.x:
							if enemy.direction == -1:
								can_turn = true
						else:
							if enemy.direction == 1:
								can_turn = true
						if can_turn:
							enemy.get_node("BasicEnemyMovement").wall_hit()
						return
	chain.execute_next([player])
