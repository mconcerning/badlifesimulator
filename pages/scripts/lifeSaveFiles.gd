extends Node2D #author(s): Ethan Scott
#THIS IS THE SCRIPT FOR THE LIFE SAVE FILES PAGE - NOT FOR LIFE SAVING AND LOADING IN GENERAL.


var buttonAction = "load" #can be either load or delete; load by default


func loadLife(saveFile): #loads a life save file (specify file NAME (extensionless))
	print("button pressed - load mode - " + saveFile)
	var dir = global.directoryGetter() #get the directory and make sure it exists
	global.currentLife = saveFile #sets currentLife to the life you clicked on
	print("now playing as " + saveFile)
	global.loadLife() #loads life


func deleteLife(saveFile, buttonName): #deletes ONE save file (specify file NAME (extensionless))
	print("button pressed - delete mode - " + saveFile)
	var dir = global.directoryGetter() #get the directory and make sure it exists
	DirAccess.remove_absolute("user://spycarsinc/bls/lives/" + saveFile + ".bls") #deletes the file
	print("removed " + saveFile)
	get_node("scrollContainer/centerContainer/vBoxContainer/" + buttonName).queue_free() #deletes the button (vBoxContainer automatically re-arranged all the other buttons so there isn't a gap where this was)
	$howManySavedLives.text = "You have " + str(DirAccess.get_files_at("user://spycarsinc/bls/lives/").size()) + " saved lives."
	if saveFile == global.currentLife: #if you're deleting the life you're currently on
		print("this is your current life, setting currentLife to ''")
		global.currentLife = "" #empty current life (there's no life)
		global.saveGame()


func buttonPressed(saveFile, buttonName):
	if buttonAction == "load":
		loadLife(saveFile)
	elif buttonAction == "delete":
		deleteLife(saveFile, buttonName)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global.getSaveLifeFileName() #we don't actually need the life save file name, we just need to make sure the user://spycarsinc/bls/lives/ directory actually exists, and this function also happens to do that
	var buttonPreload = preload("res://objects/button_default.tscn")
	var path = "user://spycarsinc/bls/lives/"
	var dir = DirAccess.get_files_at(path)
	print("directory size: " + str(dir.size())) #gets the number of files in the path provided (i.e. how many life save files exist)
	print(dir) #prints every file in the directory
	$howManySavedLives.text = "You have " + str(DirAccess.get_files_at(path).size()) + " saved lives."
	var positionDown = 0
	#adds the button for each save file
	for i in dir.size(): #runs through every file in the directory
		var button = buttonPreload.instantiate() #makes the new button not a tscn file and an actual node
		$scrollContainer/centerContainer/vBoxContainer.add_child(button) #acutally creates the new node as a child of scrollContainer/centerContainer/vBoxContainer
		button.name = "life" + str(i) #renames the new node
		button.text = dir[i].get_basename() #sets the text on the new button to the extension-less file name of the "i"th save file
		button.size.x = 0 #sets the button to the minimum width it can be
		button.position = Vector2(1080 / 2 - button.size.x / 2, positionDown) #sets its position to be centred horizontally and positionDown pixels lower on the y axis than the top of the scrollContainer
		button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		button.clip_text = true
		#gets how much x size the text takes up on the button
		var text_width = button.get_theme_font("font").get_string_size(button.text, HORIZONTAL_ALIGNMENT_LEFT, -1, button.get_theme_font_size("font_size")).x #gets the total width of the text
		button.custom_minimum_size.x = min(text_width, 1000) #sets the button's cap (by setting its minimum size to either the size of the text or 1000, whichever's lower). This leads to buttons that are too big being abruptly cut off, but it doesn't really matter all that much.
		var fileBasename = dir[i].get_basename()
		button.pressed.connect(buttonPressed.bind(fileBasename, "life" + str(i)))
	$scrollContainer/centerContainer/vBoxContainer.size.y += 50 #increases the size of the container so the scrolling doesn't stop as soon as you hit the bottom of the last button
	$scrollContainer/centerContainer.custom_minimum_size.x = $scrollContainer.size.x #sets the centerContainer's minimum x size to the scrollContainer's x size
	#extra stuff
	if global.revent.size() != 0: #if there ARE events queued to run in the revent array (the first one is the one we want to check, if are in fact any)
		if global.revent[0] == "change-save-management-mode-to-delete-o2": #if you've confirmed you'd like to enter delete mode
			global.revent.pop_at(0) #gets rid of the event
			if global.firstName != "": #if there IS a save file
				global.saveGame()
			buttonAction = "delete"
			$modeIndicator.text = "You're in DELETE mode"
			$changeMode.text = "Load mode"
		elif global.revent[0] == "change-save-management-mode-to-delete-o1": #if you've cancelled entering delete mode, stay in load mode
			global.revent.pop_at(0) #gets rid of the event
			if global.firstName != "": #if there IS a save file
				global.saveGame()
			#do nothing else, I guess


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://pages/settings.tscn")


func _on_change_mode_pressed() -> void:
	if buttonAction == "load": #if you're IN load mode, moving into DELETE mode
		global.revent.push_front("change-save-management-mode-to-delete")
		get_tree().change_scene_to_file("res://pages/event.tscn")
		#and when you come back, if you clicked option 2 (proceed), you enter delete mode
	elif buttonAction == "delete": #if youre IN delete mode, moving into LOAD mode
		buttonAction = "load"
		$modeIndicator.text = "You're in load mode"
		$changeMode.text = "Delete mode"
