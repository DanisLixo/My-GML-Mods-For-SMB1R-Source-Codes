extends Object

var immune_damage_sources = [
	"res://Scenes/Prefabs/Entities/Enemies/BowserFlame.tscn"
]

func damage_player(chain: ModLoaderHookChain, player: Player, type):
	print("Aa")
	var enemy = chain.reference_object
	if enemy.scene_file_path in immune_damage_sources:
		if player.power_state.state_name == "HammerSuit" and player.crouching:
			var particle = GibSpawner.SMOKE_PARTICLE.instantiate()
			particle.global_position = enemy.global_position + Vector2(0, 8)
			enemy.get_parent().add_sibling(particle)
			enemy.queue_free()
			return
	
	chain.execute_next_async([player, type])
