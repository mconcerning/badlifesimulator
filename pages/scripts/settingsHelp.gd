extends Node2D #author(s): Ethan Scott


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://pages/settings.tscn")


func _on_bug_report_pressed() -> void:
	OS.shell_open("https://forms.gle/YxZznTUTjh2nhyyD8")

func _on_tell_a_friend_pressed() -> void:
	var firstName = ""
	var lastName
	if randi_range(1,3000) == 1: #if it's a rare name
		var rareName = randi_range(0, global.rareFirstNames.size() - 1) #since rare names come in pairs, 
		firstName = global.rareFirstNames[rareName] #assigns the right rare first name
		lastName = global.rareLastNames[rareName] #assigns the corresponding rare last name
	else: #if NOT rare name :'((
		if randi_range(1,20) == 1: #if unisex name (1 in 20 chance)
			firstName = global.uFirstNames[randi_range(0, global.uFirstNames.size() - 1)] #assigns a random unisex first name
		else: #if you aren't given a unisex name
			match randi_range(0,1): #gives a different name depending on sex
				0:
					firstName = global.mFirstNames[randi_range(0, global.mFirstNames.size() - 1)] #assigns a male name
				1:
					firstName = global.fFirstNames[randi_range(0, global.fFirstNames.size() - 1)] #assigns a female name
		lastName = global.lastNames[randi_range(0, global.lastNames.size() - 1)] #assigns a random last name. This does not change depending on sex.
	var randomEmailProvider = ["yahoo.web", "email.gmail", "example.com", "website.web", "bomb.zip", "virus.exe", "yes.no", "hotmail", "xbox.live"]
	var email = firstName.to_lower() + "." + lastName.to_lower() + "@" + randomEmailProvider[randi_range(0, randomEmailProvider.size() - 1)]
	OS.shell_open("mailto:" + email.uri_encode() + "?subject=THE%20BEST%20GAME%20OF%20ALL%20TIME&body=Dear " + firstName + " " + lastName + ", my beloved friend of over 300 years,%0A%0AThis game single-handedly saved my marriage. It's called Bad Life Simulator and it will save yours too definitely.%0A%0ASave millions and more on couples' therapy and play this simple free mobile game instead (single-player) by clicking the simple free link below:%0A%0Ahttps://mconcerning.github.io/blslanding")

func _on_rate_pressed() -> void:
	OS.shell_open("https://forms.gle/uKNJykoguQmeX5Sj8")

func _on_feature_suggest_pressed() -> void:
	OS.shell_open("https://forms.gle/kviHDnjgqSSZh4i26")
