extends Panel

@export var spell: Spell :
	set(value): 
		spell = value
		_ready()

# Called when the node enters the scene tree for the first time.
func _ready():
	if spell:
		$VBoxContainer/SpellName.text = spell.name
		if spell.store_texture:
			$VBoxContainer/SpellPicture.texture = spell.store_texture


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
