extends Node2D #author(s): Ethan Scott


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if global.visibleSeeding:
		$vBoxContainer/enableSeeding/checkbox.frame = 1 #enabled
	else:
		$vBoxContainer/enableSeeding/checkbox.frame = 0 #disabled


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://pages/settings.tscn")


func _on_enable_seeding_pressed() -> void:
	if global.visibleSeeding:
		global.visibleSeeding = false
		$vBoxContainer/enableSeeding/checkbox.frame = 0 #disable it
	else:
		global.visibleSeeding = true
		$vBoxContainer/enableSeeding/checkbox.frame = 1 #enable it
	global.saveGame()
