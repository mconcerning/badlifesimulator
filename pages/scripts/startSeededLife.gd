extends Node2D #author(s): Ethan Scott


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://pages/main_menu_more.tscn")


func _on_paste_clipboard_pressed() -> void:
	$inputSeed.text = DisplayServer.clipboard_get()
	if DisplayServer.clipboard_get() == "" || DisplayServer.clipboard_get() == null:
		if $inputSeed.text == "Clipboard empty :(":
			$inputSeed.text = "Clipboard still empty"
		else:
			$inputSeed.text = "Clipboard empty :("


func _on_empty_input_pressed() -> void:
	$inputSeed.text = ""


func _on_play_pressed() -> void:
	if $inputSeed.text == "":
		$inputSeed.text = "nostring"
	if str(int($inputSeed.text)) == $inputSeed.text: #if the seed is numerical (if the integer version of the text is equal to the text, i.e. the text is an integer):
		global.lifeIsSeeded = true #playing a seeded life
		global.lifeSeed = int($inputSeed.text)
	else: #if seed is NOT strictly numerical, hash the string
		global.lifeIsSeeded = true
		global.lifeSeed = hash($inputSeed.text)
	get_tree().change_scene_to_file("res://pages/new_random_game.tscn")
