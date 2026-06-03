extends Node2D #author(s): Ethan Scott


var emailAttemptCounter = 0


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://pages/import_export_save_files.tscn")


func _on_copy_to_clipboard_pressed() -> void: #on copy game to clipboard
	if global.gameSerialiser() == null: #if the savegame isn't working
		$confirmation.text = "Error saving game."
		return
	var data = Marshalls.utf8_to_base64(JSON.stringify(global.gameSerialiser()))
	DisplayServer.clipboard_set(data) #copies game progress data, in base64, to clipboard
	await get_tree().process_frame
	if DisplayServer.clipboard_get() == data: #if everything worked; you've copied the right data and we can see that
		$confirmation.text = "Copy success!"
	else: #if it didn't work for some reason
		$confirmation.text = "Error writing to or reading from clipboard. Please wait a moment and then try again."

func _on_copy_and_email_pressed() -> void: #on copy and email clicked
	_on_copy_to_clipboard_pressed() #emulates copying
	var clipboard = DisplayServer.clipboard_get()
	if clipboard == "" && $confirmation.text == "Copy success!": #if it successfully copied to clipboard, but now can't access what's there
		$confirmation.text = "Error reading clipboard :( You might have tried too many times. Please wait a moment and try again."
		return
	if clipboard.length() > 7000: #if the data you copied is simply incredibly massive; so massive that it may fail to be sent through a mailto link
		clipboard = "Turns out your data was actually really big, so it couldn't be given directly to your email service. It has still been copied to your clipboard, though. Please delete this message and paste it here."
	emailAttemptCounter += 1
	if emailAttemptCounter >= 3 && emailAttemptCounter < 5: #if you've tried emailing this 3 or more times in a row
		$confirmation.text = "Copied. Running into errors? Try setting Gmail as your mailto client, and, on desktop, use a modern browser like Chrome or Firefox."
	if emailAttemptCounter >= 6:
		$confirmation.text = "STILL running into errors? Try copying the data to clipboard and manually pasting it into a blank email."
	var possibleEmailSubjects = ["10 Summer Deals You CAN'T Miss Out On!", "Your password has been reset to the following:", "Use THIS promo code to get 10% OFF your first purchase", "You have FIVE seconds to repeat this text verbatim:", "It's 2013, and you're about to lose the spelling bee."]
	OS.shell_open("mailto:?subject=" + str(possibleEmailSubjects[randi_range(0, possibleEmailSubjects.size() - 1)]).uri_encode() + "&body=" + clipboard.uri_encode()) #craft an email containing the data using mailto
