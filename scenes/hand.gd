extends Node2D

@export var empty_spot_scene: PackedScene

var vertical = false
var hovered_index = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _get_position(index: int):
	var offset = (index - 2) * Globals.CARD_SPACING
	if vertical:
		return Vector2(0, offset)
	else:
		return Vector2(offset, 0)


func reset():
	for n in $EmptySpots.get_children():
		$EmptySpots.remove_child(n)
		n.queue_free()

	for n in $Cards.get_children():
		$Cards.remove_child(n)
		n.queue_free()

	for n in range(Globals.CARDS_IN_HAND):
		var empty_spot = empty_spot_scene.instantiate()
		empty_spot.position = _get_position(n)
		$EmptySpots.add_child(empty_spot)


func add_card(card: Card, index: int):
	$Cards.add_child(card)
	$Cards.move_child(card, index)
	var offset = (index - 2) * Globals.CARD_SPACING
	if vertical:
		card.position = Vector2(0, offset)
	else:
		card.position = Vector2(offset, 0)

func take_card(index: int = hovered_index):
	var card = $Cards.get_children()[index]
	$Cards.remove_child(card)
	return card

func hide_hover_effects():
	for card in $Cards.get_children():
		card.hide_hover_effect()

func show_hover_effect(index: int):
	$Cards.get_children()[hovered_index].hide_hover_effect()
	$Cards.get_children()[index].show_hover_effect()
	hovered_index = index

func next_card():
	if hovered_index < Globals.CARDS_IN_HAND - 1:
		var new_index = hovered_index + 1
		show_hover_effect(new_index)
		return true
	return false

func prev_card():
	if hovered_index > 0:
		var new_index = hovered_index - 1
		show_hover_effect(new_index)

func peek():
	for card in $Cards.get_children():
		card.peek()
