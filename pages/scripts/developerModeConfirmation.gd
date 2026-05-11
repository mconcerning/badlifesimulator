extends Node2D #author(s): Ethan Scott


func _ready() -> void:
	if global.developerModePassword != "": #if you have a password saved
		await get_tree().process_frame
		$passwordEntry.text = global.developerModePassword #enters it
		_on_understand_proceed_pressed() #goes


func _on_go_back_pressed() -> void: #on go back pressed
	get_tree().change_scene_to_file("res://pages/new_game_confirmation.tscn") #go back


func _on_understand_proceed_pressed() -> void: #on proceed pressed
	if $passwordEntry.text == "opensesame": #if the password entered is correct
		global.developerModePassword = $passwordEntry.text
		get_tree().change_scene_to_file("res://pages/developer_mode.tscn") #go to the developer mode page
	elif $passwordEntry.text.length() == 0: #if there is NO password entered
		$incorrectPassword.text = "Please enter a password."
	else: #if there IS a password entered and it is INCORRECT
		if $incorrectPassword.text == "" || $incorrectPassword.text == "Incorrect password, again.\nPlease try again, again." || $incorrectPassword.text == "Please enter a password.":
			$incorrectPassword.text = "Incorrect password.\nPlease try again."
		elif $incorrectPassword.text == "Incorrect password.\nPlease try again.":
			$incorrectPassword.text = "Incorrect password, again.\nPlease try again, again."
