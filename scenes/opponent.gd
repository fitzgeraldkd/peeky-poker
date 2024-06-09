extends Node2D

signal next_turn
signal replace_community_card(card, player, index)
signal draw_card(instance, index)

@export var vertical = false
var ai_function : Callable
var community_node

# Called when the node enters the scene tree for the first time.
func _ready():
	$Hand.vertical = vertical
	ai_function = Callable(self, "instant_gratification")
	# ai_function = Callable(self, "random")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func reset():
	$Hand.reset()

func add_card(card: Card, index: int):
	$Hand.add_card(card, index)

func start_turn():
	$TurnIndicator.play()
	await Utils.n_seconds(1.5)
	var indeces = ai_function.call($Hand, community_node)
	play_card(indeces[0], indeces[1])

func play_card(card_index: int, community_index: int):
	var card = $Hand.take_card(card_index)
	card.position = Vector2(0, 0)
	card.reset_peek()
	card.set_face_up(true)
	replace_community_card.emit(card, self, community_index)
	await Utils.short_delay(2)
	draw_card.emit(self, card_index)
	end_turn()


func end_turn():
	$TurnIndicator.stop()
	next_turn.emit()

func peek_at_hand():
	$Hand.peek()

### AI

func random(hand, community):
	var hand_cards = hand.get_node("Cards").get_children()
	var community_cards = community.get_node("Cards").get_children()
	return [
		randi() % hand_cards.size(),
		randi() % community_cards.size(),
	]

func instant_gratification(hand, community):
	var hand_values = hand.get_node("Cards").get_children().map(
		func(card): return card.get_value()
	)
	var community_values = community.get_node("Cards").get_children().map(
		func(card): return card.get_value()
	)

	var best_points = 0
	var combinations = []
	for hand_index in range(hand_values.size()):
		for community_index in range(community_values.size()):
			var new_community = community_values.duplicate()
			new_community[community_index] =  hand_values[hand_index]

			var this_points : int
			if Utils.is_kicker(new_community, hand_values[hand_index]):
				this_points = 0
			else:
				this_points = Utils.determine_hand_points(new_community)

			if this_points > best_points:
				best_points = this_points
				combinations = [[hand_index, community_index]]
			elif this_points == best_points:
				combinations.append([hand_index, community_index])

	return combinations[randi() % combinations.size()]
