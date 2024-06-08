extends Node2D

signal next_turn
signal replace_community_card(card, index)
signal draw_card(instance, index)

@export var vertical = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Hand.vertical = vertical
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func reset():
	$Hand.reset()

func add_card(card: Card, index: int):
	$Hand.add_card(card, index)

func start_turn():
	var card_index = randi() % Globals.CARDS_IN_HAND
	var community_index = randi() % 5
	play_card(card_index, community_index)

func play_card(card_index: int, community_index: int):
	var card = $Hand.take_card(card_index)
	card.position = Vector2(0, 0)
	card.set_face_up(true)
	replace_community_card.emit(card, community_index)
	await Utils.short_delay(2)
	draw_card.emit(self, card_index)
	end_turn()


func end_turn():
	next_turn.emit()
