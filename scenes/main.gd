extends Node2D


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
	$Player.position = Vector2(viewport_size[0] / 2, viewport_size[1] - offset)
	$Opponent1.position = Vector2(offset, viewport_size[1] / 2)
	$Opponent2.position = Vector2(viewport_size[0] / 2, offset)
	$Opponent3.position = Vector2(viewport_size[0] - offset, viewport_size[1] / 2)
	$Community.position = Vector2(viewport_size[0] / 2, viewport_size[1] / 2)
	$Deck.position = Vector2(viewport_size[0] / 2 - 250, viewport_size[1] / 2 - 36)
	$Discard.position = Vector2(viewport_size[0] / 2 - 250, viewport_size[1] / 2 + 36)

func reset_game():
	$Deck.reset()
	$Player.reset()
	$Community.reset()
	$Opponent1.reset()
	$Opponent2.reset()
	$Opponent3.reset()

	var players = [
		$Player,
		$Opponent1,
		$Opponent2,
		$Opponent3,
	]

	for n in range(Globals.CARDS_IN_HAND):
		for player in players:
			draw_card(player, n)
			await Utils.n_seconds(0.08)

	for n in range(5):
		var card = $Deck.draw_card()
		card.set_face_up(true)
		$Community.replace_card(card, n)
		await Utils.n_seconds(0.08)

	$Player.start_turn()

func draw_card(player: Node, index: int):
	var card = $Deck.draw_card()
	if player == $Player:
		card.set_face_up(true)
	player.add_card(card, index)
