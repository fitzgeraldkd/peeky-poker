extends Node2D

var hovered_index = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func reset():
	pass

func replace_card(card: Card, index: int = hovered_index):
	var removed_card = get_children()[index]
	if removed_card:
		remove_child(removed_card)
	add_child(card)
	move_child(card, index)
	card.position = Vector2((index - 2) * Globals.CARD_SPACING, 0)
	return removed_card

# func hide_hover_effects():
# 	for card in $Cards.get_children():
# 		card.hide_hover_effect()

# func show_hover_effect(index: int):
# 	$Cards.get_children()[hovered_index].hide_hover_effect()
# 	$Cards.get_children()[index].show_hover_effect()
# 	hovered_index = index

# func next_card():
# 	if hovered_index < 4:
# 		var new_index = hovered_index + 1
# 		show_hover_effect(new_index)

# func prev_card():
# 	if hovered_index > 0:
# 		var new_index = hovered_index - 1
# 		show_hover_effect(new_index)
