extends Node2D

signal add_to_discard(card)
signal add_points(player, hand, is_kicker)

@export var empty_spot_scene: PackedScene

var hovered_index = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _get_position(index: int):
	var offset = (index - 2) * Globals.CARD_SPACING
	return Vector2(offset, 0)

func reset():
	for n in $EmptySpots.get_children():
		$EmptySpots.remove_child(n)
		n.queue_free()

	for n in $Cards.get_children():
		$Cards.remove_child(n)
		n.queue_free()

	for n in range(5):
		var empty_spot = empty_spot_scene.instantiate()
		empty_spot.position = _get_position(n)
		$EmptySpots.add_child(empty_spot)

func replace_card(card: Card, index: int = hovered_index):
	var removed_card : Node
	var hand
	if index < $Cards.get_children().size():
		removed_card = $Cards.get_children()[index]
		$Cards.remove_child(removed_card)
		removed_card.hide_hover_effect()
		removed_card.position = Vector2(0, 0)
		add_to_discard.emit(removed_card)
		await Utils.short_delay()
	$Cards.add_child(card)
	$Cards.move_child(card, index)
	card.position = Vector2((index - 2) * Globals.CARD_SPACING, 0)
	if $Cards.get_children().size() == 5:
		hand = _determine_hand()
	await Utils.short_delay()
	return hand

func hide_hover_effects():
	for card in $Cards.get_children():
		card.hide_hover_effect()

func show_hover_effect(index: int):
	$Cards.get_children()[hovered_index].hide_hover_effect()
	$Cards.get_children()[index].show_hover_effect()
	hovered_index = index

func next_card():
	if hovered_index < 4:
		var new_index = hovered_index + 1
		show_hover_effect(new_index)

func prev_card():
	if hovered_index > 0:
		var new_index = hovered_index - 1
		show_hover_effect(new_index)

func play_card(card: Card, player: Node, index: int = hovered_index):
	var hand = await replace_card(card, index)
	var cards = _get_card_values()
	var is_kicker = Utils.is_kicker(cards, card)
	add_points.emit(player, hand, is_kicker)


func _on_player_highlight_community():
	show_hover_effect(0)


func _on_player_unhighlight_community():
	hide_hover_effects()

func _determine_hand():
	var cards = _get_card_values()
	var hand = Utils.determine_hand(cards)
	var label = Globals.HAND_NAMES[hand]
	$HandLabel.text = label
	return hand

func _get_card_values():
	return $Cards.get_children().map(func(card): return card.get_value())

func update_kicker_labels(consecutive_kickers: int):
	var plural = "" if consecutive_kickers == 1 else "s"
	$KickerLabel.text = str(consecutive_kickers) + " consecutive kicker play" + plural
	$PenaltyLabel.text = "Penalty: x" + str(snapped(Utils.get_kicker_penalty(consecutive_kickers), 0.001))
