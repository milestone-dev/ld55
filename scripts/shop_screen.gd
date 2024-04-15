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

	spells.shuffle()
	
	spell_label_1.hide()
	spell_texture_1.hide()
	spell_icon_1.hide()
	spell_label_2.hide()
	spell_texture_2.hide()
	spell_icon_2.hide()
	spell_label_3.hide()
	spell_texture_3.hide()
	spell_icon_3.hide()

	if spells.size() >= 1:
		spell_label_1.text = spells[0].name
		spell_texture_1.texture = spells[0].store_texture
		spell_icon_1.texture = spells[0].store_icon
		spell_label_1.show()
		spell_texture_1.show()
		spell_icon_1.show()

	if spells.size() >= 2:
		spell_label_2.text = spells[1].name
		spell_texture_2.texture = spells[1].store_texture
		spell_icon_2.texture = spells[1].store_icon
		spell_label_2.show()
		spell_texture_2.show()
		spell_icon_2.show()

	if spells.size() >= 3:
		spell_label_3.text = spells[2].name
		spell_texture_3.texture = spells[2].store_texture
		spell_icon_3.texture = spells[2].store_icon
		spell_label_3.show()
		spell_texture_3.show()
		spell_icon_3.show()
	visible = true

func _on_spell_button_1_pressed() -> void:
	if spells.size() >= 1:
		learn_spell.emit(spells[0])
		visible = false

func _on_spell_button_2_pressed() -> void:
	if spells.size() >= 2:
		learn_spell.emit(spells[1])
		visible = false

func _on_spell_button_3_pressed() -> void:
	if spells.size() >= 3:
		learn_spell.emit(spells[2])
		visible = false
