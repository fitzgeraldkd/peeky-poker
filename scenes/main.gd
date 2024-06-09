extends Node2D

var players : Array[Node]
var current_player : Node
var points = {}
var consecutive_kickers = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	set_positions()
	reset_game()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func set_positions():
	var offset = 64
	var viewport_size = get_viewport().get_visible_rect().size
	var turn_indicator_offset = (Globals.CARDS_IN_HAND + 1) * Globals.CARD_SPACING / 2.0

	$Player.position = Vector2(viewport_size[0] / 2, viewport_size[1] - offset)
	$Player/PointsLabel.anchors_preset = Control.PRESET_CENTER_LEFT
	$Player/PointsLabel.position += Vector2(
		-2 * Globals.CARD_SPACING - Globals.CARD_SIZE / 2.0,
		-64,
	)
	$Player/TurnIndicator.position += Vector2(-1 * turn_indicator_offset, 0)
	$Player/PeekCard.position += Vector2(3.5 * Globals.CARD_SPACING, 0)

	$Opponent1.position = Vector2(offset, viewport_size[1] / 2)
	$Opponent1/PointsLabel.anchors_preset = Control.PRESET_CENTER_LEFT
	$Opponent1/PointsLabel.position += Vector2(
		40,
		-2 * Globals.CARD_SPACING,
	)
	$Opponent1/TurnIndicator.position += Vector2(0, -1 * turn_indicator_offset)

	$Opponent2.position = Vector2(viewport_size[0] / 2, offset)
	$Opponent2/PointsLabel.anchors_preset = Control.PRESET_CENTER_LEFT
	$Opponent2/PointsLabel.position += Vector2(
		-2 * Globals.CARD_SPACING - Globals.CARD_SIZE / 2.0,
		64,
	)
	$Opponent2/TurnIndicator.position += Vector2(turn_indicator_offset, 0)

	$Opponent3.position = Vector2(viewport_size[0] - offset, viewport_size[1] / 2)
	$Opponent3/PointsLabel.anchors_preset = Control.PRESET_CENTER_RIGHT
	$Opponent3/PointsLabel.position += Vector2(
		-40,
		-2 * Globals.CARD_SPACING,
	)
	$Opponent3/TurnIndicator.position += Vector2(0, turn_indicator_offset)

	$Community.position = Vector2(viewport_size[0] / 2, viewport_size[1] / 2)
	$Deck.position = Vector2(viewport_size[0] / 2 - 250, viewport_size[1] / 2 - 36)
	$Discard.position = Vector2(viewport_size[0] / 2 - 250, viewport_size[1] / 2 + 36)

	$Community.update_kicker_labels(0)

func reset_game():
	$Deck.reset()
	$Deck.discard_node = $Discard
	$Community.reset()

	players = [
		$Player,
		$Opponent1,
		$Opponent2,
		$Opponent3,
	]

	for player in players:
		points[player] = 0
		player.reset()

	for n in range(Globals.CARDS_IN_HAND):
		for player in players:
			draw_card(player, n)
			await Utils.n_seconds(0.08)

	for n in range(5):
		var card = $Deck.draw_card()
		card.set_face_up(true)
		$Community.replace_card(card, n)
		await Utils.n_seconds(0.08)

	current_player = $Player
	$Player.start_turn()

func draw_card(player: Node, index: int):
	var card = $Deck.draw_card()
	if player == $Player:
		card.set_face_up(true)
	player.add_card(card, index)

func next_turn():
	var current_index = players.find(current_player)
	var next_index = (current_index + 1) % players.size()
	var next_player = players[next_index]
	current_player = next_player
	next_player.start_turn()


func _on_community_add_points(player, hand, is_kicker):
	if is_kicker:
		$BadPlaySound.play()
		consecutive_kickers += 1
	else:
		$GoodPlaySound.play()
		consecutive_kickers = 0
	$Community.update_kicker_labels(consecutive_kickers)
	var points_to_add = int(Globals.HAND_POINTS[hand] * Utils.get_kicker_penalty(consecutive_kickers))
	points[player] += points_to_add
	player.get_node("PointsLabel").text = str(points[player]) + " pts"


func _on_player_peek_at_opponent_hands():
	$PeekSound.play()
	$Opponent1.peek_at_hand()
	$Opponent2.peek_at_hand()
	$Opponent3.peek_at_hand()
