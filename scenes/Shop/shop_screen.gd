extends Panel

signal learn_spell #Spell in arg1

@export var spells: Array[Spell] :
	set(value): 
		spells = value
		_ready()

# Called when the node enters the scene tree for the first time.
func _ready():
	$Items/ShopCard1/VBoxContainer/Button.connect("pressed", learn.bind(1))
	$Items/ShopCard2/VBoxContainer/Button.connect("pressed", learn.bind(2))
	$Items/ShopCard3/VBoxContainer/Button.connect("pressed", learn.bind(3))
	
	
	if spells.size() > 0:
		$Items/ShopCard1.spell = spells[0]
	if spells.size() > 1:
		$Items/ShopCard2.spell = spells[1]
	if spells.size() > 2:
		$Items/ShopCard3.spell = spells[2]
		
func learn(id):
	learn_spell.emit(spells[id])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
