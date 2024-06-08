extends Node2D

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
