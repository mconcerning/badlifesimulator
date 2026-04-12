extends Node2D #author(s): Ethan Scott


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://pages/main_menu.tscn")

func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://pages/credits.tscn")

func _on_save_files_pressed() -> void:
	get_tree().change_scene_to_file("res://pages/life_save_files.tscn")

func _on_import_export_save_files_pressed() -> void:
	get_tree().change_scene_to_file("res://pages/import_export_save_files.tscn")
