extends Node2D #author(s): Ethan Scott


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if OS.get_name() == "Android" || OS.get_name() == "iOS": #if you're on mobile
		$vBoxContainer/enableKeyboardShortcuts.disabled = true
		$vBoxContainer/enableKeyboardShortcuts/checkbox.frame = 2 #show it's disabled
	else: #if the option isn't unavaibable, checkboxes
		if global.keyboardShortcutsEnabled == true:
			$vBoxContainer/enableKeyboardShortcuts/checkbox.frame = 1 #show it's enabled
		else:
			$vBoxContainer/enableKeyboardShortcuts/checkbox.frame = 0 #show it's disabled
	if global.bigMailto == true:
		$vBoxContainer/bigMailto/checkbox.frame = 1 #enabled
	else:
		$vBoxContainer/bigMailto/checkbox.frame = 0 #disabled
	if global.cautionRelatedFun:
		$vBoxContainer/randomCautionPopups/checkbox.frame = 1 #enabled
	else:
		$vBoxContainer/randomCautionPopups/checkbox.frame = 0 #disabled
	if global.expertMode:
		$vBoxContainer/expertMode/checkbox.frame = 1 #enabled
	else:
		$vBoxContainer/expertMode/checkbox.frame = 0 #disabled


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://pages/settings.tscn")


func _on_more_info_pressed() -> void:
	get_tree().change_scene_to_file("res://pages/settings_misc_info.tscn")


func _on_enable_keyboard_shortcuts_pressed() -> void:
	if global.keyboardShortcutsEnabled == true:
		global.keyboardShortcutsEnabled = false
		$vBoxContainer/enableKeyboardShortcuts/checkbox.frame = 0 #disable it
	else:
		global.keyboardShortcutsEnabled = true
		$vBoxContainer/enableKeyboardShortcuts/checkbox.frame = 1 #enable it
	global.saveGame()


func _on_big_mailto_pressed() -> void:
	if global.bigMailto == true:
		global.bigMailto = false
		$vBoxContainer/bigMailto/checkbox.frame = 0 #disable it
	else:
		global.bigMailto = true
		$vBoxContainer/bigMailto/checkbox.frame = 1 #enable it
	global.saveGame()


func _on_random_caution_popups_pressed() -> void:
	if global.cautionRelatedFun:
		global.cautionRelatedFun = false
		$vBoxContainer/randomCautionPopups/checkbox.frame = 0 #disable it
	else:
		global.cautionRelatedFun = true
		$vBoxContainer/randomCautionPopups/checkbox.frame = 1 #enable it
	global.saveGame()


func _on_expert_mode_pressed() -> void:
	if global.expertMode:
		global.expertMode = false
		$vBoxContainer/expertMode/checkbox.frame = 0 #disable it
	else:
		global.expertMode = true
		$vBoxContainer/expertMode/checkbox.frame = 1 #enable it
	global.saveGame()
