extends Node2D #author(s): Ethan Scott


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame #must wait until the scene fully loads or else godot throws an error trying to change scene - also it flashes the default godot background colour (godot) and it's kind of jarring
	#game initialisation
	global.loadGame() #tells global.gd to load the game save file
	#window resizing
	if OS.get_name() == "Windows" || OS.get_name() == "Linux" || OS.get_name() == "macOS": #checks if you're running windows, linux, or mac
		print("you're running windows, linux, or mac")
		var _screenResolution: Vector2i = DisplayServer.screen_get_size(DisplayServer.window_get_current_screen()) #gets resolution of screen and saves it as a vector to a variable.
		DisplayServer.window_set_size(Vector2i(global.windowSize[0], global.windowSize[1])) #sets window resolution to your preferred size (by default, 640 x 360, or 1/3 of the original size, 1080 x 1920). This makes the window managable on lower-resolution screens.
		DisplayServer.window_set_position(Vector2i(100, 100)) #sets window position to the top-left of the screen. Without any repositioning, the window is by default clipping off the screen on PC displays with a resolution of 1080p or lower.
		print("window size adjusted to " + str(global.windowSize))
	#preloads the biggest scripts
	load("res://pages/scripts/event.gd")
	load("res://pages/scripts/newRandomGame.gd")
	load("res://pages/scripts/ageUp.gd")
	#loads mods
	var dirPath = "user://spycarsinc/bls/mods/" #mods path
	if not DirAccess.dir_exists_absolute(dirPath): #if the mods folder does not exist
		DirAccess.make_dir_recursive_absolute(dirPath) #create it
		print("created mod folder")
	else: #if the mods folder DOES exist
		var allModFiles = DirAccess.get_files_at(dirPath)
		if allModFiles.size() == 0: #if you have no mods
			print("no mods to load")
		else: #if you have mods
			for i in allModFiles.size(): #go through all your mods
				var modFile = dirPath + allModFiles[i] #saves the exact mod file path
				if ProjectSettings.load_resource_pack(modFile, true): #loads the mod and checks if it's real
					print("successfully loaded mod " + allModFiles[i]) #yay
				else: #if the mod isn't real
					push_warning("Mod " + allModFiles[i] + " can't load because it isn't a mod. Ensure it is a valid .pck file or it won't work.")
	#end
	print("running version " + global.versionNumber)
	get_tree().change_scene_to_file("res://pages/main_menu.tscn") #change scene to main menu
	#requires a wait time otherwise the global script is busy loading and godot will throw an error when you try to change scene
