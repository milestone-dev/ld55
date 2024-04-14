extends Panel
class_name Shop
signal learn_spell

@export var spell_texture_1 : TextureRect;
@export var spell_texture_2 : TextureRect;
@export var spell_texture_3 : TextureRect;

@export var spell_button_1 : Button;
@export var spell_button_2 : Button;
@export var spell_button_3 : Button;

@export var spells: Array[Spell];

func present_spell_choice(available_spells : Array[Spell], learned_spells : Array[Spell]):
	spells.clear();
	for spell : Spell in available_spells:
		if not spell.dependency or learned_spells.has(spell.dependency):
			spells.push_back(spell)
	update_spells()
	visible = true
			
func update_spells():
	if spells.size() == 0: return
	spells.shuffle()
	spell_button_1.text = spells[0].name
	spell_button_2.text = spells[1].name
	spell_button_3.text = spells[2].name
	
	spell_texture_1.texture = spells[0].store_texture
	spell_texture_2.texture = spells[1].store_texture
	spell_texture_3.texture = spells[2].store_texture

func learn(id):
	learn_spell.emit(spells[id])

func _on_spell_button_1_pressed() -> void:
	learn(0)
	visible = false

func _on_spell_button_2_pressed() -> void:
	learn(1)
	visible = false

func _on_spell_button_3_pressed() -> void:
	learn(2)
	visible = false
