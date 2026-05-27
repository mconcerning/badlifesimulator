extends Node2D #author(s): Ethan Scott


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if global.currentLife == "": #if you have no life to export
		$vBoxContainer/exportLife.disabled = true #you can't export it
		$vBoxContainer/exportLifeToClipboard.disabled = true #again, you have no life, you can't export the thing that you don't have
	if OS.get_name() == "Android" || OS.get_name() == "iOS" || OS.get_name() == "Web": #if you're on mobile
		$vBoxContainer/exportLife.disabled = true


func legacyLoad(path): #when you pick a legacy save file. I'm gonna be 100% honest, this feature is completely NOT necessary, but you know... It's the little things that count.
	print("selected file for legacy loading: " + path)
	if FileAccess.file_exists(path) == true: #if the file actually exists (don't know how you would have picked it if it didn't but, y'know. Crash prevention. You know how it is. Yes you do.
		var file = FileAccess.open(path, FileAccess.READ) #opens the file to read
		if file != null: #if the file is valid (NOT null)
			global.importLegacySave = path
			get_tree().change_scene_to_file("res://pages/new_random_game.tscn") #goes
		else:
			print("it failed dawg. what nightmare fuel did you just try to load")
			$confirmation.text = "it failed dawg. what nightmare fuel did you just try to load"
		file.close() #closes the file so it doesn't stay open and do anything weird


func _on_back_pressed() -> void: #go back
	get_tree().change_scene_to_file("res://pages/settings.tscn")

func _on_import_legacy_save_pressed() -> void: #opens the file picker to pick a legacy save
	$legacyImport.visible = true

func _on_legacy_import_file_selected(path: String) -> void: #when you pick a legacy save file
	legacyLoad(path)

func _on_export_save_pressed() -> void:
	$export.visible = true #opens file picker

func _on_export_dir_selected(dir: String) -> void: #opens the file picker to pick an export location
	print("exporting to " + dir)
	global.customLifeSaveDir = dir
	global.saveGame()
	$confirmation.text = "File export successful."

func _on_import_save_pressed() -> void:
	$import.visible = true

func _on_import_file_selected(path: String) -> void:
	print("importing from " + path)
	global.customLifeImportDir = path
	global.loadLife()


func _on_export_life_to_clipboard_pressed() -> void:
	get_tree().change_scene_to_file("res://pages/export_life_to_clipboard.tscn")

func _on_import_life_from_clipboard_pressed() -> void:
	get_tree().change_scene_to_file("res://pages/import_life_from_clipboard.tscn")
	#DisplayServer.clipboard_set(Marshalls.base64_to_utf8(DisplayServer.clipboard_get()))
