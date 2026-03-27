extends Node2D #author(s): Ethan Scott


#when you die
func _ready() -> void:
	global.currentLife = "" #no more currentLife
	global.saveGame()
