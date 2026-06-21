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
	OS.shell_open("mailto:" + email.uri_encode() + "?subject=BEST%20GAME%20OF%20ALL%20TIME&body=It%20single-handedly%20saved%20my%20marriage.%20It's%20called%20Bad%20Life%20Simulator%20and%20it%20will%20save%20yours%20too.%20What's%20that%3F%20You're%20NOT%20having%20marriage%20problems%3F%20You%20will%20be%20soon.%0A%0Ahttps%3A%2F%2Fmconcerning.github.io%2Fblslanding%2F")

func _on_rate_pressed() -> void:
	OS.shell_open("https://forms.gle/uKNJykoguQmeX5Sj8")

func _on_feature_suggest_pressed() -> void:
	OS.shell_open("https://forms.gle/kviHDnjgqSSZh4i26")
