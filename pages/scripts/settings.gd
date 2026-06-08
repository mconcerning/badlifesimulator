extends Node2D #author(s): Ethan Scott


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if OS.get_name() == "Web":
		$vBoxContainer/display.disabled = true
	elif OS.get_name() == "Android" || OS.get_name() == "iOS":
		$vBoxContainer/display.disabled = true


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://pages/main_menu.tscn")

func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://pages/credits.tscn")

func _on_saved_lives_pressed() -> void:
	get_tree().change_scene_to_file("res://pages/life_save_files.tscn")

func _on_import_export_save_files_pressed() -> void:
	get_tree().change_scene_to_file("res://pages/import_export_save_files.tscn")

func _on_display_pressed() -> void:
	get_tree().change_scene_to_file("res://pages/display.tscn")

func _on_misc_pressed() -> void:
	get_tree().change_scene_to_file("res://pages/settings_misc.tscn")
