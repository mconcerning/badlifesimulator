extends Node2D #author(s): Ethan Scott

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame #must wait until the scene fully loads or else godot throws an error trying to change scene - also it flashes the default godot background colour (godot) and it's kind of jarring
	if OS.get_name() == "Windows" || OS.get_name() == "Linux" || OS.get_name() == "macOS": #checks if you're running windows, linux, or mac
		print("you're running windows or linux")
		if global.windowSize == [-1, -1]: #if you haven't set a resolution yet
			var _screenResolution: Vector2i = DisplayServer.screen_get_size(DisplayServer.window_get_current_screen()) #gets resolution of screen and saves it as a vector to a variable.
			DisplayServer.window_set_size(Vector2i(360, 640)) #sets window resolution to 640 x 360, or 1/3 of the original size. This makes the window managable on lower-resolution screens.
			global.windowSize = [360, 640]
			DisplayServer.window_set_position(Vector2i(100, 100)) #sets window position to the top-left of the screen. Without any repositioning, the window is by default clipping off the screen on PC displays with a resolution of 1080p or lower.
		else: #if you have set a screen resolution
			DisplayServer.window_set_size(Vector2i(global.windowSize))
		print("window size adjusted to " + str(global.windowSize))
	print("running version " + global.versionNumber)
	global.loadGame() #tells global.gd to load game save file
	get_tree().change_scene_to_file("res://pages/main_menu.tscn") #change scene to main menu
	#requires a wait time otherwise the global script is busy loading and godot will throw an error when you try to change scene
