extends Node2D

signal next_turn
signal next_community_card
signal prev_community_card
signal replace_community_card(card, player)
signal draw_card(instance, index)
signal highlight_community
signal unhighlight_community


var is_players_turn = false
var is_card_staged = false
var staged_card_index : int

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if not is_players_turn:
		return

	if is_card_staged:
		if Input.is_action_just_pressed("left"):
			prev_community_card.emit()
		elif Input.is_action_just_pressed("right"):
			next_community_card.emit()
		elif Input.is_action_just_pressed("back"):
			unstage_card()
		elif Input.is_action_just_pressed("select"):
			play_card()
	else:
		if Input.is_action_just_pressed("left"):
			$Hand.prev_card()
		elif Input.is_action_just_pressed("right"):
			$Hand.next_card()
		elif Input.is_action_just_pressed("select"):
			stage_card()

func reset():
	$Hand.reset()

func add_card(card: Card, index: int):
	$Hand.add_card(card, index)

func start_turn():
	is_players_turn = true
	is_card_staged = false
	$Hand.show_hover_effect(0)

func end_turn():
	is_players_turn = false
	is_card_staged = false
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
