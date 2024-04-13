extends Panel

@export var spells: Array[Spell]

# Called when the node enters the scene tree for the first time.
func _ready():
	$Items/ShopCard1.spell = spells[0]
	$Items/ShopCard2.spell = spells[1]
	$Items/ShopCard3.spell = spells[2]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
