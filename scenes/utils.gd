extends Node

func n_seconds(n: float):
	return await get_tree().create_timer(n).timeout

func short_delay(n : int = 1):
	return await n_seconds(Globals.SHORT_DELAY * n)

func _is_flush(cards):
	var suit = cards[0].suit
	return cards.all(func(card): return card.suit == suit)

func _is_straight(cards):
	var values = cards.map(func(card): return card.value)
	values.sort()
	var prev_value = values[0]
	for value in values.slice(1):
		if (
			value - prev_value != 1 and
			not (prev_value == 1 and value == 10)
		):
			return false
		prev_value = value
	return true

func _count_pairs(cards):
	var counts = {}
	for card in cards:
		if card.value in counts:
			counts[card.value] += 1
		else:
			counts[card.value] = 1
	return counts

func determine_hand(cards):
	var is_flush = _is_flush(cards)
	var is_straight = _is_straight(cards)
	var is_straight_flush = is_straight && is_flush

	if is_straight_flush:
		var values = cards.map(func(card): return card.value)
		if (
			values.max() == 13 and
			values.min() == 1
		):
			return Globals.HANDS.ROYAL_FLUSH
		return Globals.HANDS.STRAIGHT_FLUSH

	if is_flush:
		return Globals.HANDS.FLUSH

	if is_straight:
		return Globals.HANDS.STRAIGHT

	var counts = _count_pairs(cards).values()
	if counts.has(4):
		return Globals.HANDS.FOUR_OF_A_KIND

	if counts.has(3):
		if counts.has(2):
			return Globals.HANDS.FULL_HOUSE
		return Globals.HANDS.THREE_OF_A_KIND

	if counts.has(2):
		if counts.count(2) == 2:
			return Globals.HANDS.TWO_PAIR
		return Globals.HANDS.PAIR

	return Globals.HANDS.HIGH_CARD


