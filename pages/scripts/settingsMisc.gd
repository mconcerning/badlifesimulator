extends Node2D #author(s): Ethan Scott


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if OS.get_name() == "Android" || OS.get_name() == "iOS": #if you're on mobile
		$vBoxContainer/enableKeyboardShortcuts.disabled = true
		$vBoxContainer/enableKeyboardShortcuts/checkbox.frame = 2 #show it's disabled
	#checkboxes
	if global.keyboardShortcutsEnabled == true:
		$vBoxContainer/enableKeyboardShortcuts/checkbox.frame = 1 #show it's enabled
	else:
		$vBoxContainer/enableKeyboardShortcuts/checkbox.frame = 0 #show it's disabled


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://pages/settings.tscn")


func _on_enable_keyboard_shortcuts_pressed() -> void:
	if global.keyboardShortcutsEnabled == true:
		global.keyboardShortcutsEnabled = false
		$vBoxContainer/enableKeyboardShortcuts/checkbox.frame = 0 #disable it
	else:
		global.keyboardShortcutsEnabled = true
		$vBoxContainer/enableKeyboardShortcuts/checkbox.frame = 1 #enable it
	global.saveGame()
