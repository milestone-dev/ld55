extends Resource
class_name Level

@export var max_concurrent_mobs : int = 100;
@export var mob_spawn_cooldown : float = 1;
@export var mob_1_type : Mobtype
@export var mob_1_probability : int
@export var mob_2_type : Mobtype
@export var mob_2_probability : int
@export var mob_3_type : Mobtype
@export var mob_3_probability : int
@export var mob_4_type : Mobtype
@export var mob_4_probability : int
@export var mob_5_type : Mobtype
@export var mob_5_probability : int

func get_mob_type() -> Mobtype:
	var mob_type_options : Array[Mobtype] = []
	for i in range(mob_1_probability): mob_type_options.push_back(mob_1_type)
	for i in range(mob_2_probability): mob_type_options.push_back(mob_2_type)
	for i in range(mob_3_probability): mob_type_options.push_back(mob_3_type)
	for i in range(mob_4_probability): mob_type_options.push_back(mob_4_type)
	for i in range(mob_5_probability): mob_type_options.push_back(mob_5_type)
	return mob_type_options.pick_random() as Mobtype
