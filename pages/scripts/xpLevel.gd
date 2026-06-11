extends Node2D #author(s): Ethan Scott


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$levelText.text = "Level " + global.commaiser(global.level)
	$progressBar.max_value = global.XPRequired
	$progressBar.value = global.XP
	$XPText.text = global.commaiser(global.XP) + " / " + global.commaiser(global.XPRequired) + "\nXP"


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://pages/main_menu.tscn")
