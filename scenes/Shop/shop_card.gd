extends Panel

@export var spell: Spell

# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/TextureRect.text = spell.name
	if spell.store_material:
		$VBoxContainer/TextureRect.material = spell.store_material
	elif spell.store_texture:
		$VBoxContainer/TextureRect.texture = spell.store_texture


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
