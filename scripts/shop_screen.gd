extends Panel

signal learn_spell

@export var spell_texture_1 : TextureRect;
@export var spell_texture_2 : TextureRect;
@export var spell_texture_3 : TextureRect;

@export var spell_button_1 : Button;
@export var spell_button_2 : Button;
@export var spell_button_3 : Button;

@export var spells: Array[Spell] :
	set(value): 
		spells = value
		update_spells()

# Called when the node enters the scene tree for the first time.
func _ready():
	update_spells()

func update_spells():
	if spells.size() == 0: return
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

func _on_spell_button_2_pressed() -> void:
	learn(1)

func _on_spell_button_3_pressed() -> void:
	learn(2)
