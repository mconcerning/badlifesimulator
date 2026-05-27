extends Node2D #author(s): Ethan Scott


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if DisplayServer.clipboard_get() != "": #if the clipboard isn't pasting automatically it will be empty. if this is the case, you probably just need to press the button manually
		$lineEdit.text = DisplayServer.clipboard_get() #if it's pasting fine, paste what you have


func _on_back_pressed():
	get_tree().change_scene_to_file("res://pages/import_export_save_files.tscn")


func _on_paste_from_clipboard_pressed() -> void:
	if DisplayServer.clipboard_get() == "": #if the clipboard is either empty or inaccessible
		$confirmation.text = "Clipboard is either empty or couldn't be read. Remember to first copy your save information from an email or the export screen first. If this was working previously, you might have pasted too many times in a short period. Please wait a moment and try again."
	else: #if your clipboard pasted successfully :)
		$lineEdit.text = DisplayServer.clipboard_get()
		$confirmation.text = "Successfully pasted from clipboard."


func _on_load_life_from_input_pressed() -> void:
	global.loadLife(true, $lineEdit.text)
