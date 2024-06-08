extends Node

func n_seconds(n: float):
	return await get_tree().create_timer(n).timeout

func short_delay(n : int = 1):
	return await n_seconds(Globals.SHORT_DELAY * n)
