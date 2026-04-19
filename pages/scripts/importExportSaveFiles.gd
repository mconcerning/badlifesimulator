extends Node2D #author(s): Ethan Scott


func legacyLoad(path): #when you pick a legacy save file. I'm gonna be 100% honest, this feature is completely NOT necessary, but you know... It's the little things that count.
	print("selected file for legacy loading: " + path)
	if FileAccess.file_exists(path) == true: #if the file actually exists (don't know how you would have picked it if it didn't but, y'know. Crash prevention. You know how it is. Yes you do.
		var file = FileAccess.open(path, FileAccess.READ) #opens the file to read
		if file: #if the file is valid
			var data = JSON.parse_string(file.get_as_text()) #saves a parsed version of a text version of the save file
			#parses the data into variables
			print(path.get_file())
			if path.get_file() == "bob.bls": #special exceptions that I will not elaborate on
				global.firstName = "Bob"
				global.lastName = "Legacy"
			else:
				global.firstName = "Legacy"
				global.lastName = "Man" #names just weren't implemented in the original, I guess, because I can't find it in the code at all
			global.age = int(data["Age"])
			global.money = int(data["Money"])
			global.joy = int(data["Joy"])
			global.intellect = int(data["Intellect"])
			global.health = int(data["Health"])
			global.looks = int(data["Looks"])
			global.evality = int(data["Evality"])
			var degreesPacked = data["Degree"].split(",") #the string needs to be turned into a packedStringArray first by seperating the elements
			global.degrees = Array(degreesPacked) #the packedStringArray needs to be turned into a regular array
			global.fullTimeJob = data["Job"]
			global.fullTimePerformance = int(data["JobPerformance"])
			global.fullTimeSalary = int(data["Salary"])
			global.partTimeJob = data["PartTimeJob"]
			global.partTimePerformance = int(data["PartTimePerformance"])
			global.currentLife = global.getSaveLifeFileName() #sets the currentLife variable to a unique file name
			global.saveGame() #saves so you can continue it right away
			print(global.currentLife)
			print("k done")
		else:
			print("it failed dawg. what nightmare fuel did you just try to load")
			$confirmation.text = "it failed dawg. what nightmare fuel did you just try to load"
		file.close() #closes the file so it doesn't stay open and do anything weird
		get_tree().change_scene_to_file("res://pages/game_menu.tscn")


func _on_back_pressed() -> void: #go back
	get_tree().change_scene_to_file("res://pages/settings.tscn")

func _on_import_legacy_save_pressed() -> void: #opens the file picker to pick a legacy save
	$legacyImport.visible = true

func _on_legacy_import_file_selected(path: String) -> void: #when you pick a legacy save file
	legacyLoad(path)

func _on_export_save_pressed() -> void:
	$export.visible = true

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


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if global.currentLife == "": #if you have no life to export
		$exportSave.disabled = true #you can't export it
