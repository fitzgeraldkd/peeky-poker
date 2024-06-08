extends Node2D

@export var card_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func reset():
	for n in get_children():
		remove_child(n)
		n.queue_free()

	for value in range(1, 14):
		# for suit in Suits:
		for suit in range(4):
			var card = card_scene.instantiate()
			card.value = value
			card.suit = suit
			add_child(card)

func draw_card():
	var cards = get_children()
	var card = cards[randi() % cards.size()]
	remove_child(card)
	return card
