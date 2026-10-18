extends Node2D #author(s): Ethan Scott


func _ready() -> void:
	if !global.visibleSeeding: #if life seeding is not enabled
		$vBoxContainer/startSeededLife.queue_free() #delete the option


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://pages/main_menu.tscn")


func _on_start_seeded_life_pressed() -> void:
	get_tree().change_scene_to_file("res://pages/start_seeded_life.tscn")
