extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func add_to_discard(card):
	$Cards.add_child(card)

func reset():
	for card in $Cards.get_children():
		$Cards.remove_child(card)
		card.queue_free()
