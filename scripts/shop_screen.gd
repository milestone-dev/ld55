extends Panel
class_name Shop
signal learn_spell

@export var spell_texture_1 : TextureRect;
@export var spell_texture_2 : TextureRect;
@export var spell_texture_3 : TextureRect;

@export var spell_icon_1 : TextureRect;
@export var spell_icon_2 : TextureRect;
@export var spell_icon_3 : TextureRect;

@export var spell_button_1 : Button;
@export var spell_button_2 : Button;
@export var spell_button_3 : Button;

@export var spell_label_1 : Label;
@export var spell_label_2 : Label;
@export var spell_label_3 : Label;

@export var spells: Array[Spell];

func present_spell_choice(available_spells : Array[Spell], learned_spells : Array[Spell]):
	spells.clear();
	for spell : Spell in available_spells:
		if !learned_spells.has(spell) and (not spell.dependency or learned_spells.has(spell.dependency)):
			spells.push_back(spell)
	update_spells()
	visible = true
	if spells.size() == 3:
		print (spells[0].name)
		print (spells[1].name)
		print (spells[2].name)
	else:
		print("Why u no spells huh?")
			
func update_spells():
	if spells.size() < 3: return
	spells.shuffle()
	spell_label_1.text = spells[0].name
	spell_label_2.text = spells[1].name
	spell_label_3.text = spells[2].name
	
	spell_texture_1.texture = spells[0].store_texture
	spell_texture_2.texture = spells[1].store_texture
	spell_texture_3.texture = spells[2].store_texture
	
	spell_icon_1.texture = spells[0].store_icon
	spell_icon_2.texture = spells[1].store_icon
	spell_icon_3.texture = spells[2].store_icon

func _on_spell_button_1_pressed() -> void:
	learn_spell.emit(spells[0])
	visible = false

func _on_spell_button_2_pressed() -> void:
	learn_spell.emit(spells[1])
	visible = false

func _on_spell_button_3_pressed() -> void:
	learn_spell.emit(spells[2])
	visible = false
