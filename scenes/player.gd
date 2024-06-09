extends Node2D

signal next_turn
signal next_community_card
signal prev_community_card
signal replace_community_card(card, player)
signal draw_card(instance, index)
signal highlight_community
signal unhighlight_community
signal peek_at_opponent_hands
signal reset_game

var is_players_turn = false
var is_card_staged = false
var staged_card_index : int
var is_hovering_peek = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if not is_players_turn:
		return

	if Input.is_action_just_pressed("reset"):
		reset_game.emit()

	if is_card_staged:
		if Input.is_action_just_pressed("left"):
			prev_community_card.emit()
		elif Input.is_action_just_pressed("right"):
			next_community_card.emit()
		elif Input.is_action_just_pressed("back") or Input.is_action_just_pressed("down"):
			unstage_card()
		elif Input.is_action_just_pressed("select") or Input.is_action_just_pressed("up"):
			play_card()
	elif is_hovering_peek:
		if Input.is_action_just_pressed("left"):
			unhover_peek()
		elif Input.is_action_just_pressed("select") or Input.is_action_just_pressed("up"):
			play_peek()
	else:
		if Input.is_action_just_pressed("left"):
			$Hand.prev_card()
		elif Input.is_action_just_pressed("right"):
			if not $Hand.next_card():
				hover_peek()
		elif Input.is_action_just_pressed("select") or Input.is_action_just_pressed("up"):
			stage_card()

func reset():
	$Hand.reset()
	unhover_peek(false)

func add_card(card: Card, index: int):
	$Hand.add_card(card, index)

func start_turn():
	is_players_turn = true
	is_card_staged = false
	is_hovering_peek = false
	$TurnIndicator.play()
	$Hand.show_hover_effect(0)

func end_turn():
	is_players_turn = false
	is_card_staged = false
	is_hovering_peek = false
	$TurnIndicator.stop()
	$Hand.hide_hover_effects()
	next_turn.emit()

func stage_card():
	staged_card_index = $Hand.hovered_index
	var card = $Hand.take_card()
	card.hide_hover_effect()
	card.position = Vector2(0, 0)
	$StagedCard.add_child(card)
	highlight_community.emit()
	is_card_staged = true

func unstage_card():
	unhighlight_community.emit()
	var card = $StagedCard.get_children()[0]
	$StagedCard.remove_child(card)
	$Hand.add_card(card, staged_card_index)
	$Hand.show_hover_effect(staged_card_index)
	is_card_staged = false

func play_card():
	var card = $StagedCard.get_children()[0]
	$StagedCard.remove_child(card)
	replace_community_card.emit(card, self)
	await Utils.short_delay(2)
	draw_card.emit(self, staged_card_index)
	end_turn()

func hover_peek():
	is_hovering_peek = true
	$Hand.hide_hover_effects()
	$PeekCard/HoverEffect.visible = true
	$PeekCard/HoverEffect.play()

func unhover_peek(hover_hand: bool = true):
	is_hovering_peek = false
	if hover_hand:
		$Hand.show_hover_effect(Globals.CARDS_IN_HAND - 1)
	$PeekCard/HoverEffect.visible = false
	$PeekCard/HoverEffect.stop()

func play_peek():
	peek_at_opponent_hands.emit()
	unhover_peek(false)
	end_turn()
