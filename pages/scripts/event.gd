extends Node2D #author(s): Ethan Scott
#handles events with 4 options


func loadList(path, splitter): #see newRandomGame.gd for more info
	return FileAccess.get_file_as_string(path).split(splitter)

func arrayCleaner(): #used for random NPC name generation - removes the last element of all IMPORTED arrays (from a txt file in res://data/), which SHOULD be occupied by dead space and no actual data
	mFirstNames.pop_back()
	fFirstNames.pop_back()
	uFirstNames.pop_back()
	lastNames.pop_back()
	rareFirstNames.pop_back()
	rareLastNames.pop_back()


func EGPGenerator(ageRange, minAge): #randomly generates EGPs (Event Generated Persons)
	#sexer
	if randi_range(1,2) == 1: #if EGP is male
		global.eventPersonSex = "M"
	else: #if EGP is female
		global.eventPersonSex = "F"
	#namer
	if randi_range(1,3000) == 1: #if they're getting a rare name, picks rare first and last names
		var rareNameIndex = randi_range(0, rareFirstNames.size() - 1) #the first and last names MUST be from the same index in their respective arrays. This generates a random index for them both to be sourced from.
		global.eventPersonFirstName = rareFirstNames[rareNameIndex] #assigns them a random rare first name
		global.eventPersonLastName = rareLastNames[rareNameIndex] #assigns them the accompanying rare last name
		return #done!
	else: #if they're NOT getting a rare name
		if randi_range(1,20) == 1: #if they're getting a unisex first name
			global.eventPersonFirstName = uFirstNames[randi_range(0, uFirstNames.size() - 1)] #assigns them a random unisex first name
		else: #if they're NOT getting a unisex first name
			if global.eventPersonSex == "M": #if they are male
				global.eventPersonFirstName = mFirstNames[randi_range(0, mFirstNames.size() - 1)]
			else: #if they are female
				global.eventPersonFirstName = fFirstNames[randi_range(0, fFirstNames.size() - 1)]
		global.eventPersonLastName = lastNames[randi_range(0, lastNames.size() - 1)] #gives them a random last name
	#ager
	global.eventPersonAge = global.age + randi_range(-ageRange, ageRange) #makes the event person between ageRange years younger and ageRange years older than you
	if global.eventPersonAge < 0: #if the event person's age is less than 0 (possible if you're under the age of the ageRange provided)
		global.eventPersonAge = 0 #sets their age to 0
	if global.eventPersonAge < minAge: #if the event person's age is less than the minimum age
		global.eventPersonAge = minAge #sets their age to the minimum age

func NPCKiller(type, index): #kills an NPC (family or misc)
	if type == "family":
		global.familyFirstNames.remove_at(index)
		global.familyLastNames.remove_at(index)
		global.familyRelationships.remove_at(index)
		global.familyTypes.remove_at(index)
		global.familyAges.remove_at(index)
		global.familySexes.remove_at(index)
	elif type == "misc":
		global.miscFirstNames.remove_at(index)
		global.miscLastNames.remove_at(index)
		global.miscRelationships.remove_at(index)
		global.miscTypes.remove_at(index)
		global.miscAges.remove_at(index)
		global.miscSexes.remove_at(index)

func pronounGenerator(type, sex): #returns pronouns so you don't have to do it manually inside events - can be one of three types: him (objective), his (possessive), he (personal), or boy (noun)
	if type == "him":
		if sex == "M": #if sex of person is male
			return "him"
		else: #if sex of person is female
			return "her"
	elif type == "his":
		if sex == "M": #if male
			return "his"
		else: #if female
			return "hers"
	elif type == "he":
		if sex == "M": #if male
			return "he"
		else: #if female
			return "she"
	elif type == "boy":
		if sex == "M": #if male
			return "boy"
		else: #if female
			return "girl"
	elif type == "guy":
		if sex == "M": #if male
			return "guy"
		else: #if female
			return "girl"


func personRemover(index, whichArray): #removes the person at index "index" in the array "whichArray" (could be family, misc, etc.)
	if whichArray == "family":
		global.familyFirstNames.pop_at(index)
		global.familyLastNames.pop_at(index)
		global.familySexes.pop_at(index)
		global.familyAges.pop_at(index)
		global.familyRelationships.pop_at(index)
		global.familyTypes.pop_at(index)
	elif whichArray == "misc":
		global.miscFirstNames.pop_at(index)
		global.miscLastNames.pop_at(index)
		global.miscSexes.pop_at(index)
		global.miscAges.pop_at(index)
		global.miscRelationships.pop_at(index)
		global.miscTypes.pop_at(index)


#again, see newRandomGame.gd for more info
var mFirstNames : Array = loadList("res://data/names/mFirstNames.txt", ", ") #loads list of masculine first names
var fFirstNames : Array = loadList("res://data/names/fFirstNames.txt", ", ") #feminine first names
var uFirstNames : Array = loadList("res://data/names/uFirstNames.txt", ", ") #unisex first names
var lastNames : Array = loadList("res://data/names/lastNames.txt", ", ") #last names
var rareFirstNames : Array = loadList("res://data/names/rareFirstNames.txt", ", ") #rare first names
var rareLastNames : Array = loadList("res://data/names/rareLastNames.txt", ", ") #rare last names


func repositionResize(): #repositions and resizes the nodes on-screen
	$heading.size.y = 0
	$body.size.y = 0
	#enabling word wrap so the buttons and text don't run off the screen if they're too long
	if $heading.get_minimum_size().x >= 1000:
		$heading.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		$heading.size.x = 900
	if $body.get_minimum_size().x >= 1000:
		$body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		$body.size.x = 900
	if $option1.get_minimum_size().x >= 1000:
		$option1.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		$option1.size.x = 900
	if $option2.get_minimum_size().x >= 1000:
		$option2.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		$option2.size.x = 900
	if $option3.get_minimum_size().x >= 1000:
		$option3.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		$option3.size.x = 900
	if $option4.get_minimum_size().x >= 1000:
		$option4.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		$option4.size.x = 900
	if is_inside_tree() == true: #if this node still exists
		await get_tree().process_frame #wait one frame so the word wrap stuff is able to apply
	else:
		return #if it doesn't exist, why are you even running this code??
	$body.position.y = $heading.position.y + $heading.get_minimum_size().y + 50 #sets position of body text to be 50 px lower than the heading text
	$option1.position.y = $body.position.y + $body.get_minimum_size().y + 100 #sets position of the option 1 button to be 100 px lower than the body text
	$option2.position.y = $option1.position.y + $option1.get_minimum_size().y + 50
	$option3.position.y = $option2.position.y + $option2.get_minimum_size().y + 50
	$option4.position.y = $option3.position.y + $option3.get_minimum_size().y + 50
	$heading.position.x = 1080 / 2 - ($heading.size.x / 2) #centres heading text horizontally on the screen
	$body.position.x = 1080 / 2 - ($body.size.x / 2)
	$option1.position.x = 1080 / 2 - ($option1.size.x / 2) #centres button horizontally on the screen
	$option2.position.x = 1080 / 2 - ($option2.size.x / 2)
	$option3.position.x = 1080 / 2 - ($option3.size.x / 2)
	$option4.position.x = 1080 / 2 - ($option4.size.x / 2)


func outcome(reventID):
	global.revent[0] = reventID
	get_tree().reload_current_scene()
	return


func goHome():
	global.revent.pop_front()
	get_tree().change_scene_to_file("res://pages/game_menu.tscn")
	return


func goToSpecific(page):
	#global.revent.pop_front() doesn't run here - you'll need to do that on the page you're going to
	get_tree().change_scene_to_file(page)
	return


func toddlerhood(): #toddlerhood base events - prefix is "toddler-"
	if global.revent[0] == "toddler-friend":
		$heading.text = "New friend?"
		EGPGenerator(4, 0) #generates a brand new, never-before-seen person to be featured in this event. Perameter is age range; in this case, the EGP will be between 4 years younger and 4 years older than you.
		$body.text = "While out visiting a family friend, a small child emerges from another room and sits down to start playing with you.\n(" + global.eventPersonFirstName + " " + global.eventPersonLastName + ", " + global.eventPersonSex + ", " + str(global.eventPersonAge) + " years old)"
		$option1.text = "Befriend " + pronounGenerator("him", global.eventPersonSex)
		$option2.text = "Ignore " + pronounGenerator("him", global.eventPersonSex)
		$option3.modulate.a = 0
		$option4.modulate.a = 0
		$credit.text = "mconcerning"
	elif global.revent[0] == "toddler-0": #if first element in the revent array is the following one
		$heading.text = "Parkscream"
		$body.text = "While out with your family at the park, you notice that there is an ice cream shop situated across the road."
		if global.familyTypes.has("Mother"): #if you have a mother
			$option1.text = "Ask your mother for one"
		elif global.familyTypes.has("Father"): #if you have no mother, only (a) father(s)
			$option1.text = "Ask your father for one"
		$option2.text = "Cry until you get one"
		$option3.text = "Bite your tongue and don't say anything"
		$option4.modulate.a = 0 #there is no fourth option; this makes the button transparent (opacity of 0) so you can't see it. There is no way to interact with it either, provided its click functionality isn't implemented within the "if" statement for this event.
		$credit.text = "mconcerning"
	elif global.revent[0] == "toddler-1":
		$heading.text = "The stolen teddy"
		$body.text = "At daycare, another toddler takes away your favorite teddy bear from you and they refuse to give it back."
		$option1.text = "Cry loudly until a teacher intervenes"
		$option2.text = "Find another toy to play with."
		$option3.text = "Snatch the teddy back yourself."
		$option4.modulate.a = 0
		$credit.text = "Orsted1"



func childhood(): #childhood base events - prefix is "child-"
	if global.revent[0] == "child-friend":
		$heading.text = "New friend?"
		EGPGenerator(3, 0) #generates an event person to use
		if randi_range(1,2) == 1: #random body text variation
			$body.text = "While out and about with your " + str(global.familyTypes[0]).to_lower() +  ", you strike up a conversation with a random kid and you two seem to get along pretty well.\n("
		else: #random body text variation
			$body.text = "While out and about with your " + str(global.familyTypes[0]).to_lower() +  ", you strike up a conversation with a random kid and you two seem to get along pretty well.\n("
		$body.text = $body.text + global.eventPersonFirstName + " " + global.eventPersonLastName + ", " + global.eventPersonSex + ", " + str(global.eventPersonAge) + " years old)" #appends EGP details to the end of the body text
		$option1.text = "Befriend " + pronounGenerator("him", global.eventPersonSex)
		$option2.text = "Ignore " + pronounGenerator("him", global.eventPersonSex)
		$option3.modulate.a = 0
		$option4.modulate.a = 0
		$credit.text = "mconcerning"
	elif global.revent[0] == "child-0":
		var relativeOfChoice = global.familyRelationships.find(global.familyRelationships.min()) #which relative will be featured in this event? gets the index of the family member you have the lowest relationship with.
		$heading.text = "Soft start"
		$body.text = "It's your birthday party, and it's time to open presents! But the first present you open from your " + str(global.familyTypes[relativeOfChoice]).to_lower() + ", " + str(global.familyFirstNames[relativeOfChoice]) + ", was just a bunch of pillows and other bedding. You kind of wish they had just gotten you something else instead."
		$option1.text = "Thank them anyways"
		$option2.text = "Thank them enthusiastically"
		$option3.text = "Pitch a fit and cry"
		if global.evality >= 90: #if you're like, REALLY evil
			$option4.text = "Kill " + pronounGenerator("him", global.familySexes[relativeOfChoice]) #uh oh!???
		else: #if you're not
			$option4.modulate.a = 0 #don't worry, you can't press it on accident
		$credit.text = "Goblin + mconcerning"


func teenagehood(): #teenage base events - prefix is "teenager-"
	if global.revent[0] == "teenager-friend":
		$heading.text = "New friend?"
		EGPGenerator(3, 10)
		if randi_range(1,2) == 1: #body text variation
			$body.text = "While visiting a family friend, " #this isn't unfinished, it gets appended to in a second
		else:
			$body.text = "While out with family, " #this isn't unfinished, it gets appended to in a second
		$body.text = $body.text + "you run into a " + pronounGenerator("boy", global.eventPersonSex) + " named " + global.eventPersonFirstName + ". You start talking and realise you have a lot of chemistry."
		$option1.text = "Befriend " + pronounGenerator("him", global.eventPersonSex)
		$option2.text = "Ask " + pronounGenerator("him", global.eventPersonSex) + " out"
		$option3.text = "Leave " + pronounGenerator("him", global.eventPersonSex) + " alone"
		$option4.modulate.a = 0
		$credit.text = "mconcerning"
	


func adulthood(): #adult base events - prefix is "adult-"
	if global.revent[0] == "adult-friend":
		$heading.text = "New connection"
		EGPGenerator(7, 18)
		if randi_range(1,2) == 1: #body text variation
			$body.text = "While out running errands, you strike up a conversation with a random " + pronounGenerator("guy", global.eventPersonSex) + " and you really hit it off.\n("
		else: #body text variation
			$body.text = "While eating out at a restaurant, you strike up a conversation with a random " + pronounGenerator("guy", global.eventPersonSex) + " and you really hit it off.\n("
		$body.text = $body.text + global.eventPersonFirstName + " " + global.eventPersonLastName + ", " + global.eventPersonSex + ", " + str(global.eventPersonAge) + " years old)"
		$option1.text = "Befriend " + pronounGenerator("him", global.eventPersonSex)
		$option2.text = "Ask " + pronounGenerator("him", global.eventPersonSex) + " on a date"
		$option3.text = "Leave " + pronounGenerator("him", global.eventPersonSex) + " alone"
		$option4.modulate.a = 0
		$credit.text = "mconcerning"
	elif global.revent[0] == "adult-0":
		$heading.text = "Bully Returns"
		$body.text = "You meet one of your childhood bullies after you've graduated highschool."
		$option1.text = "Shame them for their behaviour" 
		$option2.text = "Avoid them"
		$option3.text = "Say hi and move on"
		$option4.modulate.a = 0
		$credit.text = "Goblin"


func elderhood(): #elderly base events - prefix is "elder-"
	if global.revent[0] == "elder-friend":
		$heading.text = "New connection"
		EGPGenerator(12, 55)
		if randi_range(1,2) == 1: #body text variation
			$body.text = "While out running errands, you strike up a conversation with a random person and you realise you have a lot in common.\n("
		else: #body text variation
			$body.text = "While eating out at a restaurant, you strike up a conversation with a random person and you realise you have a lot in common.\n("
		$body.text = $body.text + global.eventPersonFirstName + " " + global.eventPersonLastName + ", " + global.eventPersonSex + ", " + str(global.eventPersonAge) + " years old)"
		$option1.text = "Befriend " + pronounGenerator("him", global.eventPersonSex)
		$option2.text = "Ask " + pronounGenerator("him", global.eventPersonSex) + " on a date"
		$option3.text = "Leave " + pronounGenerator("him", global.eventPersonSex) + " alone"
		$option4.modulate.a = 0
		$credit.text = "mconcerning"


func multiAgeRange(): #runs events that span across multiple age ranges
	pass


func specialised(): #runs any specialised, non-age-up events
	if global.revent[0] == "change-save-management-mode-to-delete":
		$heading.text = "Please confirm"
		$body.text = "Are you sure you want to enter delete mode?\nANY save file you press will be PERMANENTLY deleted. This action CANNOT be undone.\nPress the ''Load mode'' button above your save files to switch back to load mode at any time.\nYou cannot delete your MAIN game save here. Rest assured, no matter what, that will stay intact. You can, however, delete individual lives, including the one you're playing on currently."
		$option1.text = "Nevermind, back to load mode"
		$option2.text = "I understand, please let me delete stuff"
		$option3.modulate.a = 0
		$option4.modulate.a = 0


func _on_option_1_pressed() -> void: #on option 1 selected
	#event - option 1 will be an actual option
	if global.revent[0] == "toddler-0" || global.revent[0] == "child-0" || global.revent[0] == "child-friend" || global.revent[0] == "toddler-friend" || global.revent[0] == "child-friend" || global.revent[0] == "teenager-friend" || global.revent[0] == "adult-friend" || global.revent[0] == "elder-friend" || global.revent[0] == "change-save-management-mode-to-delete":
		outcome(global.revent[0] + "-o1")
	#confirmation - option 1 will be the only button available when the event's purpose is only to display information. Generally, the button will say "Okay".
	elif global.revent[0] == "toddler-0-o1" || global.revent[0] == "toddler-0-o2" || global.revent[0] == "toddler-0-o3":
		goHome()
	elif global.revent[0] == "child-0-o1" || global.revent[0] == "child-0-o2" || global.revent[0] == "child-0-o3" || global.revent[0] == "child-0-o4":
		goHome()
	elif global.revent[0] == "toddler-friend-o1" || global.revent[0] == "toddler-friend-o2":
		goHome()
	elif global.revent[0] == "child-friend-o1" || global.revent[0] == "child-friend-o2":
		goHome()
	elif global.revent[0] == "teenager-friend-o1" || global.revent[0] == "teenager-friend-o2" || global.revent[0] == "teenager-friend-o3":
		goHome()
	elif global.revent[0] == "adult-friend-o1" || global.revent[0] == "adult-friend-o2" || global.revent[0] == "adult-friend-o3":
		goHome()
	elif global.revent[0] == "elder-friend-o1" || global.revent[0] == "elder-friend-o2" || global.revent[0] == "elder-friend-o3":
		goHome()
	elif global.revent[0] == "toddler-1":
		outcome(global.revent[0] + "-o1")
	elif global.revent[0] == "adulthood-0":
		goHome()
	elif global.revent[0] == "toddler-1-o1":
		goHome()
	elif global.revent[0] == "adulthood-0-o1":


func _on_option_2_pressed() -> void: #on option 2 selected
	if global.revent[0] == "toddler-0" || global.revent[0] == "child-0" || global.revent[0] == "toddler-friend" || global.revent[0] == "child-friend" || global.revent[0] == "teenager-friend" || global.revent[0] == "adult-friend" || global.revent[0] == "elder-friend" || global.revent[0] == "change-save-management-mode-to-delete":
		outcome(global.revent[0] + "-o2")
	elif global.revent[0] == "toddler-1":
		outcome(global.revent[0] + "-o2")
	elif global.revent[0] == "adulthood-0":
		goHome()


func _on_option_3_pressed() -> void: #on option 3 selected
	outcome(global.revent[0] + "-o3")

func _on_option_4_pressed() -> void: #on option 4 selected
	if global.revent[0] == "child-0":
		if global.evality >= 90: #if you meet the requirements to access this option
			outcome(global.revent[0] + "-o4")
	outcome(global.revent[0] + "-o4")


func option1outcomes(): #option 1 has been picked
	if global.revent[0] == "toddler-friend-o1" || global.revent[0] == "child-friend-o1":
		$heading.text = "Yay"
		$body.text = "You befriended " + global.eventPersonFirstName + " " + global.eventPersonLastName + "!"
		$option1.text = "Hooray"
		$option2.modulate.a = 0
		$option3.modulate.a = 0
		$option4.modulate.a = 0
		#adds the EGP to your miscellanious relationships array
		global.miscSexes.append(global.eventPersonSex)
		global.miscFirstNames.append(global.eventPersonFirstName)
		global.miscLastNames.append(global.eventPersonLastName)
		global.miscAges.append(global.eventPersonAge)
		global.miscRelationships.append(randi_range(20, 50))
		global.miscTypes.append("Friend")
	elif global.revent[0] == "teenager-friend-o1":
		if randi_range(1,3) == 1: #if they refuse to be your friend
			$heading.text = "That's awkward..."
			$body.text = "You try to befriend " + pronounGenerator("him", global.eventPersonSex) + ", but " + pronounGenerator("he", global.eventPersonSex) + " rejects you."
			$option1.text = "Dang"
		else: #if they agree to be your friend
			$heading.text = "Sweet"
			$body.text = "You befriended " + global.eventPersonFirstName + " " + global.eventPersonLastName + "."
			$option1.text = "Okay"
		$option2.modulate.a = 0
		$option3.modulate.a = 0
		$option4.modulate.a = 0
	elif global.revent[0] == "adult-friend-o1" || global.revent[0] == "elder-friend-o1":
		if randi_range(1,2) == 1: #if they refuse to be your friend
			$heading.text = "Okay..."
			$body.text = "You try to befriend " + pronounGenerator("him", global.eventPersonSex) + ", but " + pronounGenerator("he", global.eventPersonSex) + " rejects you."
			$option1.text = "Dang"
		else: #if they agree to be your friend
			$heading.text = "A blossoming friendship"
			$body.text = "You befriended " + global.eventPersonFirstName + " " + global.eventPersonLastName + "."
			$option1.text = "Okay"
		$option2.modulate.a = 0
		$option3.modulate.a = 0
		$option4.modulate.a = 0
	elif global.revent[0] == "toddler-0-o1":
		$heading.text = "Nooo"
		if global.familyTypes.has("Mother"): #if you have a mother
			$body.text = "She says no. You go home depressed and don't leave your room for 11 days.\n- 10 Joy" #mother-specific body text
		elif global.familyTypes.has("Father"): #if you have a father
			$body.text = "He says no. You go home depressed and don't keave your room for 11 days.\n- 10 Joy" #father-specific body text
		$option1.text = "Okay"
		$option2.modulate.a = 0
		$option3.modulate.a = 0
		$option4.modulate.a = 0
		global.joy -= 10 #deducts 10 joy
	elif global.revent[0] == "child-0-o1":
		var relativeOfChoice = global.familyRelationships.find(global.familyRelationships.min()) #gets the index of the gifter
		$heading.text = "Wow... It's just... Wow."
		if global.evality < 30: #if evality is under 30, you feel bad about lying
			$body.text = "They appreciate your kind words, but you feel kind of bad about lying.\n+ 5 relationship with your " + str(global.familyTypes[relativeOfChoice]) + " " + str(global.familyFirstNames[relativeOfChoice]) + ", - 5 Joy"
			global.joy -= 5
		else: #if evality is 30 or over, you don't feel bad
			$body.text = "They appreciate your kind words.\n+ 5 relationship with your " + str(global.familyTypes[relativeOfChoice]).to_lower() + ", " + str(global.familyFirstNames[relativeOfChoice])
		$option1.text = "Okay"
		$option2.modulate.a = 0
		$option3.modulate.a = 0
		$option4.modulate.a = 0
		global.familyRelationships[relativeOfChoice] += 5 #adds 5 to the relationship you have with the gifter
		global.evality += 3 #since you did something semi-bad, you become slightly desensitised to doing bad things
	elif global.revent[0] == "change-save-management-mode-to-delete-o1":
		goToSpecific("res://pages/life_save_files.tscn")
	elif global.revent[0] == "toddler-1-o1":
		$heading.text = "Returned toy"
		$body.text = "The teacher returns your teddy, but the other toddler glares at you. +5 joy"
		$option1.text = "Okay"
		$option2.modulate.a = 0
		$option3.modulate.a = 0
		$option4.modulate.a = 0
		global.joy+=5
		global.evality+=2
	elif global.revent[0] == "adult-0-o1":
		$heading.text = "Shame on you!"
		$body.text = "You shamne your high school bully, but it mostly feels akward. +3 joy"
		$option1.text = "Okay"
		$option2.modulate.a = 0
		$option3.modulate.a = 0
		$option4.modulate.a = 0
		global.joy+=3

func option2outcomes(): #option 2 has been picked
	if global.revent[0] == "toddler-friend-o2" || global.revent[0] == "child-friend-o2":
		$heading.text = "...Can you go away?"
		$body.text = "You ignore " + pronounGenerator("him", global.eventPersonSex) + " for a while, and eventually " + pronounGenerator("he", global.eventPersonSex) + " goes away."
		$option1.text = "Okay"
		$option2.modulate.a = 0
		$option3.modulate.a = 0
		$option4.modulate.a = 0
		global.evality += 4 #i mean, it was kind of rude...
	if global.revent[0] == "teenager-friend-o2":
		if randi_range(1, round((36 - global.looks / 4) / 2) - 3) == 1: #if you're more physically attractive, you have a higher chance of being accepted
			$heading.text = "What's your number?"
			$body.text = "You ask " + pronounGenerator("him", global.eventPersonSex) + " out on a date, and " + pronounGenerator("he", global.eventPersonSex) + " says yes.\nJoy + 15"
			global.joy += 15
			#if you already have an S/O, break up with (removes) them
			for i in global.miscTypes.size(): #runs through every non-familial relationship
				if global.miscTypes[i] == "Boyfriend" || global.miscTypes[i] == "Girlfriend": #and if they're your gf/bf
					personRemover(i, "misc") #removes them
				#for loops automatically increase the variable they use (in this case, i) so no need to manually increment it
			#adds them to your relationships
			global.miscFirstNames.append(global.eventPersonFirstName)
			global.miscLastNames.append(global.eventPersonLastName)
			global.miscSexes.append(global.eventPersonSex)
			global.miscAges.append(global.eventPersonAge)
			global.miscRelationships.append(randi_range(40, 80))
			global.miscTypes.append((pronounGenerator("boy", global.eventPersonSex) + "friend").capitalize())
		else: #they DON'T want to date you
			$heading.text = "..."
			$body.text = "You ask " + pronounGenerator("him", global.eventPersonSex) + " out, but " + pronounGenerator("he", global.eventPersonSex) + " rejects you.\nJoy - 15"
			global.joy -= 15
		$option1.text = "Okay"
		$option2.modulate.a = 0
		$option3.modulate.a = 0
		$option4.modulate.a = 0
	elif global.revent[0] == "adult-friend-o2":
		$heading.text = "You wanna go out sometime?"
		if randi_range(1, round((36 - global.looks / 4) / 2) - 3) == 1: #if you're more physically attractive, you have a higher chance of being accepted
			$body.text = "You ask " + pronounGenerator("him", global.eventPersonSex) + " out on a date, and " + pronounGenerator("he", global.eventPersonSex) + " says yes.\nJoy + 15"
			global.joy += 15
			#if you already have an S/O, break up with (removes) them
			for i in global.miscTypes.size(): #runs through every non-familial relationship
				if global.miscTypes[i] == "Boyfriend" || global.miscTypes[i] == "Girlfriend": #and if they're your gf/bf
					personRemover(i, "misc") #removes them
				#for loops automatically increase the variable they use (in this case, i) so no need to manually increment it
			#adds them to your relationships
			global.miscFirstNames.append(global.eventPersonFirstName)
			global.miscLastNames.append(global.eventPersonLastName)
			global.miscSexes.append(global.eventPersonSex)
			global.miscAges.append(global.eventPersonAge)
			global.miscRelationships.append(randi_range(40, 80))
			global.miscTypes.append((pronounGenerator("boy", global.eventPersonSex) + "friend").capitalize())
		else: #they DON'T want to date you
			$body.text = "You ask " + pronounGenerator("him", global.eventPersonSex) + " out, but " + pronounGenerator("he", global.eventPersonSex) + " rejects you.\nJoy - 15"
			global.joy -= 15
		$option1.text = "Okay"
		$option2.modulate.a = 0
		$option3.modulate.a = 0
		$option4.modulate.a = 0
	elif global.revent[0] == "elder-friend-o2":
		if randi_range(1, round(36 - global.looks / 4) - 3) == 1: #if you're more physically attractive, you have a higher chance of being accepted. You have lower chances either way though since you're older.
			$heading.text = "Better late than never"
			$body.text = "You ask " + pronounGenerator("him", global.eventPersonSex) + " out on a date, and " + pronounGenerator("he", global.eventPersonSex) + " says yes.\nJoy + 15"
			global.joy += 15
			#if you already have an S/O, break up with (removes) them
			for i in global.miscTypes.size(): #runs through every non-familial relationship
				if global.miscTypes[i] == "Boyfriend" || global.miscTypes[i] == "Girlfriend": #and if they're your gf/bf
					personRemover(i, "misc") #removes them
				#for loops automatically increase the variable they use (in this case, i) so no need to manually increment it
			#adds them to your relationships
			global.miscFirstNames.append(global.eventPersonFirstName)
			global.miscLastNames.append(global.eventPersonLastName)
			global.miscSexes.append(global.eventPersonSex)
			global.miscAges.append(global.eventPersonAge)
			global.miscRelationships.append(randi_range(40, 80))
			global.miscTypes.append((pronounGenerator("boy", global.eventPersonSex) + "friend").capitalize())
		else: #they DON'T want to date you
			$heading.text = str(global.age) + " and still unmarried"
			$body.text = "You ask " + pronounGenerator("him", global.eventPersonSex) + " out on a date, but " + pronounGenerator("he", global.eventPersonSex) + " rejects you.\nJoy - 15"
			global.joy -= 15
		$option1.text = "Okay"
		$option2.modulate.a = 0
		$option3.modulate.a = 0
		$option4.modulate.a = 0
	elif global.revent[0] == "toddler-0-o2":
		$heading.text = "You screamed for ice cream"
		if global.familyTypes.has("Mother"):
			$body.text = "You cry, and eventually your mother gives in and buys you one.\nJoy + 5, relationship with mother -5"
			global.familyRelationships[global.familyTypes.find("Mother")] -= 5
		elif global.familyTypes.has("Father"):
			$body.text = "You cry, and eventually your father gives in and buys you one.\nJoy + 5, relationship with father -5"
			global.familyRelationships[global.familyTypes.find("Father")] -= 5
		$option1.text = "Okay"
		$option2.modulate.a = 0
		$option3.modulate.a = 0
		$option4.modulate.a = 0
		global.joy += 5
		global.evality += 4
	elif global.revent[0] == "child-0-o2":
		var relativeOfChoice = global.familyRelationships.find(global.familyRelationships.min()) #gets the index of the gifter
		$heading.text = "Wow! It's just... Wow!"
		if global.evality < 40: #if evality is under 40, you feel bad about lying
			$body.text = "They appreciate your kind words, so much so that they surprise you with another $50, but you feel really bad about lying.\n+ 8 relationship with your " + str(global.familyTypes[relativeOfChoice]).to_lower() + ", " + str(global.familyFirstNames[relativeOfChoice]) + ", - 10 Joy, + $50"
			global.joy -= 10
		else: #if evality is 40 or above, you don't feel bad
			$body.text = "They appreciate your kind words, so much so that they surprise you with another $50.\n+ 8 relationship with your " + str(global.familyTypes[relativeOfChoice]).to_lower() + ", " + str(global.familyFirstNames[relativeOfChoice]) + ", + $50"
		$option1.text = "Okay"
		$option2.modulate.a = 0
		$option3.modulate.a = 0
		$option4.modulate.a = 0
		global.familyRelationships[relativeOfChoice] += 8
		global.money += 50
		global.evality += 4 #since you did something bad, you become slightly desensitised to doing bad things
	elif global.revent[0] == "change-save-management-mode-to-delete-o2":
		goToSpecific("res://pages/life_save_files.tscn")
	elif global.revent[0] == "toddler-1-o2":
		$heading.text = "New friend"
		$body.text = "You find a new toy, and make a new friend who enjoys playing with the same toys as you. +3 joy"
		$option1.text = "Okay"
		$option2.modulate.a = 0
		$option3.modulate.a = 0
		$option4.modulate.a = 0
		global.joy+=3
		if global.evality<=2:
			global.evality=0
		else:
			global.evality-=2 

func option3outcomes(): #option 3 has been picked
	if global.revent[0] == "teenager-friend-o3" || global.revent[0] == "adult-friend-o3" || global.revent[0] == "elder-friend-o3":
		if global.evality >= 60:
			$heading.text = "Can you go away"
			$body.text = "You stop talking to " + pronounGenerator("him", global.eventPersonSex) + " and " + pronounGenerator("he", global.eventPersonSex) + " eventually goes away."
			global.evality += 5
		else:
			$heading.text = "Alright, bye"
			$body.text = "You finish talking to " + pronounGenerator("him", global.eventPersonSex) + " and you go your seperate ways."
		$option1.text = "Okay"
		$option2.modulate.a = 0
		$option3.modulate.a = 0
		$option4.modulate.a = 0
	elif global.revent[0] == "toddler-0-o3":
		$heading.text = "If you insist"
		if global.familyTypes.has("Mother"):
			$body.text = "Your mother points to the shop and asks you if you want to get one. You go on to have a great day out together.\nJoy + 10, relationship with mother + 10"
			global.familyRelationships[global.familyTypes.find("Mother")] += 10
		elif global.familyTypes.has("Father"):
			$body.text = "Your father points to the shop and asks you if you want to get one. You go on to have a great day out together.\nJoy + 10, relationship with father + 10"
			global.familyRelationships[global.familyTypes.find("Father")] += 10
		$option1.text = "Okay"
		$option2.modulate.a = 0
		$option3.modulate.a = 0
		$option4.modulate.a = 0
		global.joy += 10
	elif global.revent[0] == "child-0-o3":
		var relativeOfChoice = global.familyRelationships.find(global.familyRelationships.min()) #gets the index of the gifter
		$heading.text = "Wow, this sucks"
		var parents = [] #indexes of all parents; size determines whether "parent" should be plural or not in the body text
		for i in global.familyTypes.size(): #runs through every family member to check for parents
			if global.familyTypes[i] == "Mother" || global.familyTypes[i] == "Father": #if family member at the index we're checking is a parent
				parents.append(i)
		if parents.size() > 1: #if you have more than one parent
			$body.text = "Your parents scold you for being unappreciative.\n- 8 relationship with gifter, -8 relationship with parents, - 12 Joy"
		else: #if you only have one parent
			$body.text = "Your parent scolds you for being unappreciative.\n- 8 relationship with gifter, -8 relationship with parents, - 12 Joy"
		$option1.text = "Okay"
		$option2.modulate.a = 0
		$option3.modulate.a = 0
		$option4.modulate.a = 0
		global.familyRelationships[relativeOfChoice] -= 8 #deduct 8 relationship with gifter
		for i in parents.size(): #runs through every parent
				global.familyRelationships[parents[i]] -= 8 #deducts 8 relationship from the parent at the index of parents[i] (parents stores indexes, so the parents at position i in the parents array could have a different index to themself in the other family arrays.
		global.joy -= 12
	elif global.revent[0] == "toddler-1-o3":
		$heading.text = "Returned toy"
		$body.text = "The toddler starts crying, and the teacher scolds you. -2 joy"
		$option1.text = "Okay"
		$option2.modulate.a = 0
		$option3.modulate.a = 0
		$option4.modulate.a = 0
		global.joy-=2
		global.evality+=5
	elif global.revent[0] == "adult-0-o3":
		$heading.text = "Ammends made"
		$body.text = "You catch up, and they apologize for their actions, all is well. +15 joy"
		$option1.text = "Okay"
		$option2.modulate.a = 0
		$option3.modulate.a = 0
		$option4.modulate.a = 0
		global.joy += 10
		global.evality -= 5 if global.evality >= 5 else global.evality

func option4outcomes(): #option 4 has been picked
	if global.revent[0] == "child-0-o4":
		var relativeOfChoice = global.familyRelationships.find(global.familyRelationships.min()) #gets the index of the relative featured in this event
		$heading.text = "No one can ever know."
		$body.text = "You kill your " + global.familyTypes[relativeOfChoice].to_lower() + " in cold blood. You push " + pronounGenerator("him", global.familySexes[relativeOfChoice]) + " down the stairs while no-one's looking.\n+ 100 Intellect"
		$option1.text = "Okay"
		$option2.modulate.a = 0
		$option3.modulate.a = 0
		$option4.modulate.a = 0
		NPCKiller("family", relativeOfChoice) #kills uncle
		#stat effects
		global.intellect = 100
		global.crimes.append("1st-degree-murder")
		global.crimesSeverity.append(100)


func eventer(): #runs all the functions
	toddlerhood()
	childhood()
	teenagehood()
	adulthood()
	elderhood()
	multiAgeRange()
	specialised()
	option1outcomes()
	option2outcomes()
	option3outcomes()
	option4outcomes()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if global.revent.size() == 0: #if there are no events queued
		get_tree().change_scene_to_file("res://pages/game_menu.tscn")
		return
	print("showing event " + str(global.revent[0])) #prints the first event ID (the one that is about to be shown) in the revent array
	if global.firstName != "": #if there IS a save file
		global.saveGame()
	await get_tree().process_frame #waits for frame to be processed first to avoid weirdness
	eventer()
	repositionResize()
