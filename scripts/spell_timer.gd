extends Object

class_name SpellTimer
var player : Player
var effect_timer: float = 10;
var spell : Spell;

var effect_cooldown : float = 0;

func _init(input_player: Player, input_spell:Spell) -> void:
	self.player = input_player
	self.spell = input_spell
	self.effect_timer = spell.effect_duration
	prints(spell.name, "added")
	
func update(delta:float) -> bool:
	match spell.projectile_behavior:
		Spell.SpellProjectileBehavior.ADD_TIMED:
			effect_timer -= delta
			if effect_timer <= 0:
				return true;
			elif effect_cooldown <= 0:
				effect_cooldown = spell.effect_cooldown_max;
				# fire projectile using player
				player.shoot_projectile(spell, true)
				print("timed projectile")
			elif effect_cooldown > 0:
				effect_cooldown -= delta
	return false;
