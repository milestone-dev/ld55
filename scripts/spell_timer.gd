extends Object

class_name SpellTimer
var player : Player
var effect_timer: float = 10;
var spell : Spell;

var area_of_effect_node : AreaOfEffect

var effect_cooldown : float = 0;

func _init(input_player: Player, input_spell:Spell) -> void:
	self.player = input_player
	self.spell = input_spell
	self.effect_timer = spell.effect_duration
	#prints(spell.name, "added")
	
	match spell.effect_area_behavior:
		Spell.SpellEffectAreaBehavior.TIMED:
			if spell.area_of_effect_scene:
				area_of_effect_node = spell.area_of_effect_scene.instantiate()
			if spell.area_of_effect_on_player:
				player.add_child(area_of_effect_node)
			else:
				player.get_parent().add_child(area_of_effect_node)
	
func update(delta:float) -> bool:
	match spell.projectile_behavior:
		Spell.SpellProjectileBehavior.ADD_TIMED:
			#prints(spell.name, "processing aoe timed")
			effect_timer -= delta
			if effect_timer <= 0:
				if area_of_effect_node: area_of_effect_node.queue_free()
				return true;
			elif effect_cooldown <= 0:
				effect_cooldown = spell.effect_cooldown_max;
				# fire projectile using player
				player.shoot_projectile(spell, true)
				#print("timed projectile")
			elif effect_cooldown > 0:
				effect_cooldown -= delta
	match spell.effect_area_behavior:
		Spell.SpellProjectileBehavior.ADD_TIMED:
			effect_timer -= delta
			if effect_timer <= 0:
				if area_of_effect_node: area_of_effect_node.queue_free()
				player.speed_multiplier = 1;
				return true;
			elif effect_cooldown <= 0:
				player.speed_multiplier = spell.speed_multiplier
				effect_cooldown = spell.effect_cooldown_max;
				if area_of_effect_node:
					if area_of_effect_node.collider:
						var bodies = area_of_effect_node.collider.get_overlapping_bodies()
						for mob : Mob in player.get_tree().get_nodes_in_group("mob"):
							if bodies.has(mob):
								player.add_experience(mob.take_damage(spell.attack_damage))
					else:
						for mob : Mob in player.get_tree().get_nodes_in_group("mob"):
							if area_of_effect_node.global_position.distance_to(mob.global_position) < spell.attack_range:
								player.add_experience(mob.take_damage(spell.attack_damage))
			elif effect_cooldown > 0:
				effect_cooldown -= delta
	return false;
