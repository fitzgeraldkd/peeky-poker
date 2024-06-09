extends Node2D
class_name Card

const VALUE_FRAMES = {
	1: 3,
	2: 4,
	3: 5,
	4: 6,
	5: 7,
	6: 8,
	7: 9,
	8: 10,
	9: 11,
	10: 12,
	11: 13,
	12: 14,
	13: 15,
}

const SUIT_FRAMES = {
	0: 17,
	1: 18,
	2: 19,
	3: 20,
}

var value : int
var suit : int
var revealed_to_player = false
var is_face_up = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Front.visible = false
	$Front/Number.frame = VALUE_FRAMES[value]
	$Front/Suit.frame = SUIT_FRAMES[suit]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func discard():
	pass

func set_face_up(new_face_up: bool):
	is_face_up = new_face_up
	$Front.visible = new_face_up

func show_hover_effect():
	$HoverEffect.visible = true
	$HoverEffect.play()

func hide_hover_effect():
	$HoverEffect.visible = false
	$HoverEffect.stop()

func get_value():
	return {
		"value": value,
		"suit": suit,
	}

func peek():
	revealed_to_player = true
	$Front.modulate = Color(1.0, 1.0, 1.0, 0.5)
	set_face_up(true)

func reset_peek():
	revealed_to_player = false
	$Front.modulate = Color(1.0, 1.0, 1.0, 1.0)
