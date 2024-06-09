extends Node2D

@export var card_scene: PackedScene
var discard_node : Node

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func reset():
	for n in $Cards.get_children():
		$Cards.remove_child(n)
		n.queue_free()

	for value in range(1, 14):
		# for suit in Suits:
		for suit in range(4):
			var card = card_scene.instantiate()
			card.value = value
			card.suit = suit
			$Cards.add_child(card)

func draw_card():
	var cards = $Cards.get_children()

	if cards.size() == 0:
		cards = discard_node.get_node("Cards").get_children()
		for card in cards:
			discard_node.get_node("Cards").remove_child(card)
			card.set_face_up(false)
			$Cards.add_child(card)

	var card = cards[randi() % cards.size()]
	$Cards.remove_child(card)
	$Label.text = str($Cards.get_children().size())
	return card
