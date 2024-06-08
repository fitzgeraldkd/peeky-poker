extends Node2D

signal add_to_discard(card)

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
	if index < $Cards.get_children().size():
		removed_card = $Cards.get_children()[index]
		$Cards.remove_child(removed_card)
		removed_card.hide_hover_effect()
		removed_card.position = Vector2(0, 0)
		add_to_discard.emit(removed_card)
	$Cards.add_child(card)
	$Cards.move_child(card, index)
	card.position = Vector2((index - 2) * Globals.CARD_SPACING, 0)

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

func play_card(card: Card):
	replace_card(card)


func _on_player_highlight_community():
	show_hover_effect(0)


func _on_player_unhighlight_community():
	hide_hover_effects()
