extends Node2D #author(s): Ethan Scott


var emailAttemptCounter = 0


#enable this if you want it :)
#func randomRecipientGenerator(): #an abridged and slightly altered version of the random name generator used in newRandomGame.gd that usually picks one for the player. Here, it's used to generate a random email for you to send your thing to. If you want. To get sued.
	#var firstName = ""
	#var lastName
	#if randi_range(1,3000) == 1: #if it's a rare name
		#var rareName = randi_range(0, global.rareFirstNames.size() - 1) #since rare names come in pairs, 
		#firstName = global.rareFirstNames[rareName] #assigns the right rare first name
		#lastName = global.rareLastNames[rareName] #assigns the corresponding rare last name
	#else: #if NOT rare name :'((
		#if randi_range(1,20) == 1: #if unisex name (1 in 20 chance)
			#firstName = global.uFirstNames[randi_range(0, global.uFirstNames.size() - 1)] #assigns a random unisex first name
		#else: #if you aren't given a unisex name
			#match randi_range(0,1): #gives a different name depending on sex
				#0:
					#firstName = global.mFirstNames[randi_range(0, global.mFirstNames.size() - 1)] #assigns a male name
				#1:
					#firstName = global.fFirstNames[randi_range(0, global.fFirstNames.size() - 1)] #assigns a female name
		#lastName = global.lastNames[randi_range(0, global.lastNames.size() - 1)] #assigns a random last name. This does not change depending on sex.
	#var randomEmailProvider = ["yahoo.web", "email.gmail", "example.com", "website.web", "bomb.zip", "virus.exe", "yes.no", "hotmail", "xbox.live"]
	#return firstName.to_lower() + "." + lastName.to_lower() + "@" + randomEmailProvider[randi_range(0, randomEmailProvider.size() - 1)]


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://pages/import_export_save_files.tscn")


func _on_copy_to_clipboard_pressed() -> void:
	global.loadLife(false)
	if global.lifeSerialiser() == null: #if saving didn't work
		$confirmation.text = "Error saving life."
		return
	var data = Marshalls.utf8_to_base64(JSON.stringify(global.lifeSerialiser()))
	DisplayServer.clipboard_set(data) #copies life data, in base64, to clipboard (you can't cheat that easily (it's still pretty easy (all you have to know is what base64 is)))
	await get_tree().process_frame
	if DisplayServer.clipboard_get() == data: #if everything worked; you've copied the right data and we can see that
		$confirmation.text = "Copy success!"
	else: #if it didn't work for some reason
		$confirmation.text = "Error writing to or reading from clipboard."


func _on_copy_and_email_pressed() -> void: #i want to copy this to clipboard AND email the result
	_on_copy_to_clipboard_pressed() #emulates pressing the copy button to copy to clipboard
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
	var possibleEmailSubjects = ["About the dog...", "FREE MICROSOFT GIFT CARD!! CLICK HERE", "I know where you live", "Ambiguous string of gibberish", "Dear Recipient,", "Im-port? Sorry, the borders are closed", "I am sending you this email whether you like it or not", "I wonder how Apple Intelligence would summarise this", "To Mr. Beast", "I think it's pretty clear what this email is about;"] #this is just for fun: random email subjects. No need to worry about making the text url-compatible, that is done automatically via .uri_encode() below.
	OS.shell_open("mailto:?subject=" + str(possibleEmailSubjects[randi_range(0, possibleEmailSubjects.size() - 1)]).uri_encode() + "&body=" + clipboard.uri_encode()) #craft an email containing the data using mailto
	#OS.shell_open("mailto:?" + str(randomRecipientGenerator()).uri_encode() + "subject=" + str(possibleEmailSubjects[randi_range(0, possibleEmailSubjects.size() - 1)]).uri_encode() + "&body=" + clipboard) #not used, but it can be if you want.
