extends Node2D #author(s): Ethan Scott
#handles all events


func optionRemover(optionXOnwards): #disables and changes the opacity to 0 of unused buttons (optionXOnwards is the button you want to disable. It and every button below it will be disabled)
	if optionXOnwards <= 2:
		$option2.disabled = true #disables the button
		$option2.hide() #makes it invisible
	if optionXOnwards <= 3:
		$option3.disabled = true
		$option3.hide()
	if optionXOnwards <= 4:
		$option4.disabled = true
		$option4.hide()
	if optionXOnwards <= 5:
		$option5.disabled = true
		$option5.hide()


func EGPGenerator(ageRange, minAge): #randomly generates EGPs (Event Generated Persons)
	#sexer
	if randi_range(1,2) == 1: #if EGP is male
		global.eventPersonSex = "M"
	else: #if EGP is female
		global.eventPersonSex = "F"
	#namer
	if randi_range(1,3000) == 1: #if they're getting a rare name, picks rare first and last names
		var rareNameIndex = randi_range(0, global.rareFirstNames.size() - 1) #the first and last names MUST be from the same index in their respective arrays. This generates a random index for them both to be sourced from.
		global.eventPersonFirstName = global.rareFirstNames[rareNameIndex] #assigns them a random rare first name
		global.eventPersonLastName = global.rareglobal.lastNames[rareNameIndex] #assigns them the accompanying rare last name
		return #done!
	else: #if they're NOT getting a rare name
		if randi_range(1,20) == 1: #if they're getting a unisex first name
			global.eventPersonFirstName = global.uFirstNames[randi_range(0, global.uFirstNames.size() - 1)] #assigns them a random unisex first name
		else: #if they're NOT getting a unisex first name
			if global.eventPersonSex == "M": #if they are male
				global.eventPersonFirstName = global.mFirstNames[randi_range(0, global.mFirstNames.size() - 1)]
			else: #if they are female
				global.eventPersonFirstName = global.fFirstNames[randi_range(0, global.fFirstNames.size() - 1)]
		global.eventPersonLastName = global.lastNames[randi_range(0, global.lastNames.size() - 1)] #gives them a random last name
	#ager
	global.eventPersonAge = global.age + randi_range(-ageRange, ageRange) #makes the event person between ageRange years younger and ageRange years older than you
	if global.eventPersonAge < 0: #if the event person's age is less than 0 (possible if you're under the age of the ageRange provided)
		global.eventPersonAge = 0 #sets their age to 0
	if global.eventPersonAge < minAge: #if the event person's age is less than the minimum age
		global.eventPersonAge = minAge #sets their age to the minimum age


func personRemover(index): #removes the person at index "index" in the NPCs array
	global.personFirstNames.pop_at(index)
	global.personLastNames.pop_at(index)
	global.personSexes.pop_at(index)
	global.personAges.pop_at(index)
	global.personRelationships.pop_at(index)
	global.personTypes.pop_at(index)


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
	if $option5.get_minimum_size().x >= 1000:
		$option5.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		$option5.size.x = 900
	if is_inside_tree() == true: #if this node still exists
		await get_tree().process_frame #wait one frame so the word wrap stuff is able to apply
	else:
		return #if it doesn't exist, why are you even running this code??
	$body.position.y = $heading.position.y + $heading.get_minimum_size().y + 50 #sets position of body text to be 50 px lower than the heading text
	$option1.position.y = $body.position.y + $body.get_minimum_size().y + 100 #sets position of the option 1 button to be 100 px lower than the body text
	$option2.position.y = $option1.position.y + $option1.get_minimum_size().y + 50
	$option3.position.y = $option2.position.y + $option2.get_minimum_size().y + 50
	$option4.position.y = $option3.position.y + $option3.get_minimum_size().y + 50
	$option5.position.y = $option4.position.y + $option4.get_minimum_size().y + 50
	@warning_ignore("integer_division")
	$heading.position.x = 1080 / 2 - ($heading.size.x / 2) #centres heading text horizontally on the screen
	@warning_ignore("integer_division")
	$body.position.x = 1080 / 2 - ($body.size.x / 2)
	@warning_ignore("integer_division")
	$option1.position.x = 1080 / 2 - ($option1.size.x / 2) #centres button horizontally on the screen
	@warning_ignore("integer_division")
	$option2.position.x = 1080 / 2 - ($option2.size.x / 2)
	@warning_ignore("integer_division")
	$option3.position.x = 1080 / 2 - ($option3.size.x / 2)
	@warning_ignore("integer_division")
	$option4.position.x = 1080 / 2 - ($option4.size.x / 2)
	@warning_ignore("integer_division")
	$option5.position.x = 1080 / 2 - ($option5.size.x / 2)


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
		$option1.text = "Befriend " + global.pronounGenerator("him", global.eventPersonSex)
		$option2.text = "Ignore " + global.pronounGenerator("him", global.eventPersonSex)
		optionRemover(3)
		$credit.text = "mconcerning"
	elif global.revent[0] == "toddler-0": #if first element in the revent array is the following one
		$heading.text = "Parkscream"
		$body.text = "While out with your family at the park, you notice that there is an ice cream shop situated across the road."
		if global.personTypes.has("Mother"): #if you have a mother
			$option1.text = "Ask your mother for one"
		elif global.personTypes.has("Father"): #if you have no mother, only (a) father(s)
			$option1.text = "Ask your father for one"
		$option2.text = "Cry until you get one"
		$option3.text = "Bite your tongue and don't say anything"
		optionRemover(4) #there is no fourth or fifth option; this makes the buttons transparent (opacity of 0) so you can't see it, and disables them so you can't click them.
		$credit.text = "mconcerning"


func childhood(): #childhood base events - prefix is "child-"
	if global.revent[0] == "child-friend":
		$heading.text = "New friend?"
		EGPGenerator(3, 0) #generates an event person to use
		if randi_range(1,2) == 1: #random body text variation
			$body.text = "While out and about with your " + str(global.personTypes[0]).to_lower() +  ", you strike up a conversation with a random kid and you two seem to get along pretty well.\n("
		else: #random body text variation
			$body.text = "While out and about with your " + str(global.personTypes[0]).to_lower() +  ", you strike up a conversation with a random kid and you two seem to get along pretty well.\n("
		$body.text = $body.text + global.eventPersonFirstName + " " + global.eventPersonLastName + ", " + global.eventPersonSex + ", " + str(global.eventPersonAge) + " years old)" #appends EGP details to the end of the body text
		$option1.text = "Befriend " + global.pronounGenerator("him", global.eventPersonSex)
		$option2.text = "Ignore " + global.pronounGenerator("him", global.eventPersonSex)
		optionRemover(3)
		$credit.text = "mconcerning"
	elif global.revent[0] == "child-0":
		var relativeOfChoice = global.personRelationships.find(global.personRelationships.min()) #which relative will be featured in this event? gets the index of the family member you have the lowest relationship with.
		$heading.text = "Soft start"
		$body.text = "It's your birthday party, and it's time to open presents! But the first present you open from your " + str(global.personTypes[relativeOfChoice]).to_lower() + ", " + str(global.personFirstNames[relativeOfChoice]) + ", was just a bunch of pillows and other bedding. You kind of wish they had just gotten you something else instead."
		$option1.text = "Thank them anyways"
		$option2.text = "Thank them enthusiastically"
		$option3.text = "Pitch a fit and cry"
		if global.evality >= 90: #if you're like, REALLY evil
			$option4.text = "Kill " + global.pronounGenerator("him", global.personSexes[relativeOfChoice]) #uh oh!???
		else: #if you're not
			optionRemover(4) #don't worry; you can't still click it on accident
		optionRemover(5)
		$credit.text = "Goblin + mconcerning"


func teenagehood(): #teenage base events - prefix is "teenager-"
	if global.revent[0] == "teenager-friend":
		$heading.text = "New friend?"
		EGPGenerator(3, 10)
		if randi_range(1,2) == 1: #body text variation
			$body.text = "While visiting a family friend, " #this isn't unfinished, it gets appended to in a second
		else:
			$body.text = "While out with family, " #this isn't unfinished, it gets appended to in a second
		$body.text = $body.text + "you run into a " + global.pronounGenerator("boy", global.eventPersonSex) + " named " + global.eventPersonFirstName + ". You start talking and realise you have a lot of chemistry."
		$option1.text = "Befriend " + global.pronounGenerator("him", global.eventPersonSex)
		$option2.text = "Ask " + global.pronounGenerator("him", global.eventPersonSex) + " out"
		$option3.text = "Leave " + global.pronounGenerator("him", global.eventPersonSex) + " alone"
		optionRemover(4)
		$credit.text = "mconcerning"


func adulthood(): #adult base events - prefix is "adult-"
	if global.revent[0] == "adult-friend":
		$heading.text = "New connection"
		EGPGenerator(7, 18)
		if randi_range(1,2) == 1: #body text variation
			$body.text = "While out running errands, you strike up a conversation with a random " + global.pronounGenerator("guy", global.eventPersonSex) + " and you really hit it off.\n("
		else: #body text variation
			$body.text = "While eating out at a restaurant, you strike up a conversation with a random " + global.pronounGenerator("guy", global.eventPersonSex) + " and you really hit it off.\n("
		$body.text = $body.text + global.eventPersonFirstName + " " + global.eventPersonLastName + ", " + global.eventPersonSex + ", " + str(global.eventPersonAge) + " years old)"
		$option1.text = "Befriend " + global.pronounGenerator("him", global.eventPersonSex)
		$option2.text = "Ask " + global.pronounGenerator("him", global.eventPersonSex) + " on a date"
		$option3.text = "Leave " + global.pronounGenerator("him", global.eventPersonSex) + " alone"
		optionRemover(4)
		$credit.text = "mconcerning"


func elderhood(): #elderly base events - prefix is "elder-"
	if global.revent[0] == "elder-friend":
		$heading.text = "New connection"
		EGPGenerator(12, 55)
		if randi_range(1,2) == 1: #body text variation
			$body.text = "While out running errands, you strike up a conversation with a random person and you realise you have a lot in common.\n("
		else: #body text variation
			$body.text = "While eating out at a restaurant, you strike up a conversation with a random person and you realise you have a lot in common.\n("
		$body.text = $body.text + global.eventPersonFirstName + " " + global.eventPersonLastName + ", " + global.eventPersonSex + ", " + str(global.eventPersonAge) + " years old)"
		$option1.text = "Befriend " + global.pronounGenerator("him", global.eventPersonSex)
		$option2.text = "Ask " + global.pronounGenerator("him", global.eventPersonSex) + " on a date"
		$option3.text = "Leave " + global.pronounGenerator("him", global.eventPersonSex) + " alone"
		optionRemover(4)
		$credit.text = "mconcerning"


func multiAgeRange(): #runs events that span across multiple age ranges
	pass


func specialised(): #runs any miscellanious specialised, non-age-up events
	if global.revent[0] == "change-save-management-mode-to-delete":
		$heading.text = "Please confirm"
		$body.text = "Are you sure you want to enter delete mode?\nANY save file you press will be PERMANENTLY deleted. This action CANNOT be undone.\nPress the ''Load mode'' button above your save files to switch back to load mode at any time.\nYou cannot delete your MAIN game save here. Rest assured, no matter what, that will stay intact. You can, however, delete individual lives, including the one you're playing on currently."
		$option1.text = "Nevermind, back to load mode"
		$option2.text = "I understand, please let me delete stuff"
		optionRemover(3)
	elif global.revent[0] == "child-labour-is-outlawed":
		$heading.text = "But why"
		$body.text = "You're too young to get a job. Child labour is thoroughly illegal. Unless..."
		$option1.text = "Dang it"
		optionRemover(2)
	elif global.revent [0] == "university-degree-picked" || global.revent[0] == "university-degree-picked-o2-refused-o1" || global.revent[0] == "university-degree-picked-o4-rejected-o1":
		$heading.text = "University degree"
		$body.text = "You picked a"
		if global.degreePicked == "education":
			$body.text += "n Education degree, which costs a total of $25,000 to undertake.\n"
			if global.money < 25000: #if you don't have enough money to pay the degree upfront
				$body.text += "Since you don't have enough money to pay for it upfront ($" + str(global.money) + "), you can choose to take out a 20-year loan to cover the costs with an interest rate of 8%, or you can apply for a scholarship."
				$option1.disabled = true #you can't pay for it upfront; this option is unavailable
			else: #if you have enough money to pay for it upfront
				$body.text += "You have enough money to pay for it upfront ($" + str(global.money) + "), but you can still choose to take out a 20-year loan to cover the costs with an interest rate of 8%, or apply for a scholarship."
			$option1.text = "Pay for it with cash"
			if global.personTypes.count("Mother") + global.personTypes.count("Father") >= 2: #if you have two parents
				$option2.text = "Ask your parents to pay"
			elif global.personTypes.count("Mother") + global.personTypes.count("Father") == 1: #if you only have one parent
				if global.personTypes.find("Mother") == -1: #if you only have a father
					$option2.text = "Ask your father to pay"
				else: #if you only have a mother
					$option2.text = "Ask your mother to pay"
			else: #if you have no parents
				$option2.text = "Ask your parents to pay"
				$option2.disabled = true #if you have no parents, you can't exactly ask them to pay for your tuition
			$option3.text = "Take out the loan"
			$option4.text = "Apply for a scholarship"
			optionRemover(5)
			if global.revent[0] == "university-degree-picked-o2-refused-o1": #if your parents already refused to pay for your tuition
				$option2.disabled = true #you can't just keep pestering them until they cave
			elif global.revent[0] == "university-degree-picked-o4-rejected-o1": #if your application for a scholarship was already denied
				$option4.disabled = true #you can't try it again
			global.revent[0] = "university-degree-picked"


func relationships(): #specialised relationship events
	if global.revent[0] == "compliment-relationship":
		global.history.append("compliment-relationship")
		const possibleCompliments = ["racist", "really cool", "incredibly attractive", "talented", "fun to be around", "kind", "productive", "intelligent", "smart", "energetic", "creative", "interesting", "a hero", "the best", "a tangerine"]
		var complimentSelected = possibleCompliments[randi_range(0, possibleCompliments.size() - 1)] #picks a compliment to give
		if global.cooldown("compliment-relationship") >= 3: #if you've complimented them too much recently
			$heading.text = "Whatever you say"
			$body.text = "Your " + global.personTypes[global.IDClicked].to_lower() + ", " + global.personFirstNames[global.IDClicked] + ", said " + global.pronounGenerator("he", global.personSexes[global.IDClicked]) + "'s sick of you complimenting " + global.pronounGenerator("him", global.personSexes[global.IDClicked]) + " so much and you need to calm down."
		else: #if you haven't complimented them 3 or more times already this year
			$heading.text = "How tertiary"
			$body.text = "You told your " + global.personTypes[global.IDClicked].to_lower() + ", " + global.personFirstNames[global.IDClicked] + ", that " + global.pronounGenerator("he", global.personSexes[global.IDClicked]) + "'s " + complimentSelected + "."
			if complimentSelected == "racist" || (complimentSelected == "incredibly attractive" && global.personCategories[global.IDClicked] == "family"): #if you accidentally didn't compliment them
				$heading.text = "...Thanks."
				global.personRelationships[global.IDClicked] -= randi_range(5, 20)
			else: #if you did compliment them
				var relationshipGained = randi_range(4, 7)
				global.personRelationships[global.IDClicked] += relationshipGained
				$body.text += "\n+ " + str(relationshipGained) + " relationship."
		$option1.text = "Okay"
		optionRemover(2)


func confirmation(): #non-random confirmation events that tell you that something just happened
	if global.revent[0] == "enrolled-in-primary-school" || global.revent[0] == "enrolled-in-high-school":
		if global.revent[0] == "enrolled-in-primary-school":
			$heading.text = "Primary school"
		else: #if you're being enrolled in high school
			$heading.text = "High school"
		$body.text = "Your "
		if global.personTypes.count("Mother") + global.personTypes.count("Father") > 1: #if you have more than one parent
			$body.text += "parents have enrolled you in " + global.schoolName + "!"
		elif global.personTypes.count("Mother") + global.personTypes.count("Father") == 1: #if you only have one parent
			if global.personTypes.find("Mother") != -1: #if you have only a mother
				$body.text += "mother has enrolled you in " + global.schoolName + "!"
			elif global.personTypes.find("Father") != -1: #if you have only a father
				$body.text += "father has enrolled you in " + global.schoolName + "!"
			else: #if you have neither a mother or a father (technically could happen, if they die)
				$body.text = "You have been enrolled in " + global.schoolName + "."
		$option1.text = "Okay"
		optionRemover(2)
	elif global.revent[0] == "graduated-high-school":
		$heading.text = "Graduate"
		$body.text = "Congratulations! You graduated high school."
		$option1.text = "Take some time off"
		$option2.text = "Apply to a university"
		optionRemover(3)
	elif global.revent[0] == "graduated-university":
		$heading.text = "Job time"
		$body.text = "Congratulations! You graduated University."
		$option1.text = "Take some time off"
		optionRemover(2)
	elif global.revent[0] == "study-harder":
		var dudStudyChance = round(global.intellect / 2)
		if global.intellect <= 20: #if you're so intelligent that you're more inclined to have a total dud of a study session
			dudStudyChance = dudStudyChance / 4 #increases your chance of having a poor study session
		if randi_range(1, max(1, dudStudyChance)) == 1 || global.cooldown("study-harder") > 3: #if you had a total dud of a study session; happens either at random (higher chance if you're less intelligent) or if you've already studied 3 or more times this year (you're burned out)
			match randi_range(1,2): #random heading text variation
				1:
					$heading.text = "What"
				2:
					$heading.text = "Huh"
			var intellectGained = randi_range(3, 5)
			var joySubtracted = randi_range(3, 10)
			$body.text = "You tried to study for " + str(randi_range(2, 6)) + " hours, but absorbed next to no information.\n+ " + str(intellectGained) + " Intellect, - " + str(joySubtracted) + " Joy"
			$option1.text = "Okay"
			optionRemover(2)
			global.intellect += intellectGained
			global.joy -= joySubtracted
			global.history.append("study-harder")
		else:
			match randi_range(1, 4): #random heading text variation
				1:
					$heading.text = "Hunkering down"
				2:
					$heading.text = "Hunkering through"
				3:
					$heading.text = "Hunkering left"
				4:
					$heading.text = "Hunkering in"
			var joySubtracted = randi_range(round(global.intellect/10), 14 - round(global.intellect/10))
			$body.text = "You studied for " + str(max(2, round(global.intellect/20))) + " hours.\n+ " + str(round(global.intellect/7)) + " school performance, + " + str(round(global.intellect/12) + 2) + " Intellect, - " + str(joySubtracted) + " Joy"
			global.schoolPerformance += round(global.intellect/7)
			global.intellect += round(global.intellect/12) + 2
			global.joy -= joySubtracted
			global.history.append("study-harder")
			$option1.text = "Okay"
			optionRemover(2)


func _on_option_1_pressed() -> void: #on option 1 selected
	#event - option 1 will be an actual option
	if global.revent[0] == "toddler-0" || global.revent[0] == "child-0" || global.revent[0] == "child-friend" || global.revent[0] == "toddler-friend" || global.revent[0] == "child-friend" || global.revent[0] == "teenager-friend" || global.revent[0] == "adult-friend" || global.revent[0] == "elder-friend" || global.revent[0] == "change-save-management-mode-to-delete" || global.revent[0] == "university-degree-picked" || global.revent[0] == "university-degree-picked-o2-refused" || global.revent[0] == "university-degree-picked-o4-rejected":
		outcome(global.revent[0] + "-o1")
	#confirmation - option 1 will be the only button available when the event's purpose is only to display information. Generally, the button will say "Okay".
	elif global.revent[0] == "toddler-0-o1" || global.revent[0] == "toddler-0-o2" || global.revent[0] == "toddler-0-o3" || global.revent[0] == "child-0-o1" || global.revent[0] == "child-0-o2" || global.revent[0] == "child-0-o3" || global.revent[0] == "child-0-o4" || global.revent[0] == "toddler-friend-o1" || global.revent[0] == "toddler-friend-o2" || global.revent[0] == "child-friend-o1" || global.revent[0] == "child-friend-o2" || global.revent[0] == "teenager-friend-o1" || global.revent[0] == "teenager-friend-o2" || global.revent[0] == "teenager-friend-o3" || global.revent[0] == "adult-friend-o1" || global.revent[0] == "adult-friend-o2" || global.revent[0] == "adult-friend-o3" || global.revent[0] == "elder-friend-o1" || global.revent[0] == "elder-friend-o2" || global.revent[0] == "elder-friend-o3" || global.revent[0] == "child-labour-is-outlawed" || global.revent[0] == "enrolled-in-primary-school" || global.revent[0] == "enrolled-in-high-school" || global.revent[0] == "graduated-high-school" || global.revent[0] == "study-harder" || global.revent[0] == "university-degree-picked-o1" || global.revent[0] == "university-degree-picked-o2" || global.revent[0] == "university-degree-picked-o3" || global.revent[0] == "university-degree-picked-o4" || global.revent[0] == "university-degree-picked-o2" || global.revent[0] == "graduated-university" || global.revent[0] == "compliment-relationship":
		goHome()


func _on_option_2_pressed() -> void: #on option 2 selected
	outcome(global.revent[0] + "-o2")


func _on_option_3_pressed() -> void: #on option 3 selected
	outcome(global.revent[0] + "-o3")


func _on_option_4_pressed() -> void: #on option 4 selected
	if global.revent[0] == "child-0":
		if global.evality >= 90: #if you meet the requirements to access this option
			outcome(global.revent[0] + "-o4")
	outcome(global.revent[0] + "-o4")


func _on_option_5_pressed() -> void: #on option 5 selected
	pass # Replace with function body.


func option1outcomes(): #option 1 has been picked
	if global.revent[0] == "toddler-friend-o1" || global.revent[0] == "child-friend-o1":
		$heading.text = "Yay"
		$body.text = "You befriended " + global.eventPersonFirstName + " " + global.eventPersonLastName + "!"
		$option1.text = "Hooray"
		optionRemover(2)
		#adds the EGP to your relationships array
		global.personSexes.append(global.eventPersonSex)
		global.miscFirstNames.append(global.eventPersonFirstName)
		global.miscLastNames.append(global.eventPersonLastName)
		global.personAges.append(global.eventPersonAge)
		global.personRelationships.append(randi_range(20, 50))
		global.personTypes.append("Friend")
		global.personCategories.append("misc")
	elif global.revent[0] == "teenager-friend-o1":
		if randi_range(1,3) == 1: #if they refuse to be your friend
			$heading.text = "That's awkward..."
			$body.text = "You try to befriend " + global.pronounGenerator("him", global.eventPersonSex) + ", but " + global.pronounGenerator("he", global.eventPersonSex) + " rejects you."
			$option1.text = "Dang"
		else: #if they agree to be your friend
			$heading.text = "Sweet"
			$body.text = "You befriended " + global.eventPersonFirstName + " " + global.eventPersonLastName + "."
			#adds the EGP to your relationships array
			global.personSexes.append(global.eventPersonSex)
			global.miscFirstNames.append(global.eventPersonFirstName)
			global.miscLastNames.append(global.eventPersonLastName)
			global.personAges.append(global.eventPersonAge)
			global.personRelationships.append(randi_range(20, 50))
			global.personTypes.append("Friend")
			global.personCategories.append("misc")
			$option1.text = "Okay"
		optionRemover(2)
	elif global.revent[0] == "adult-friend-o1" || global.revent[0] == "elder-friend-o1":
		if randi_range(1,2) == 1: #if they refuse to be your friend
			$heading.text = "Okay..."
			$body.text = "You try to befriend " + global.pronounGenerator("him", global.eventPersonSex) + ", but " + global.pronounGenerator("he", global.eventPersonSex) + " rejects you."
			$option1.text = "Dang"
		else: #if they agree to be your friend
			$heading.text = "A blossoming friendship"
			$body.text = "You befriended " + global.eventPersonFirstName + " " + global.eventPersonLastName + "."
			#adds the EGP to your relationships array
			global.personSexes.append(global.eventPersonSex)
			global.miscFirstNames.append(global.eventPersonFirstName)
			global.miscLastNames.append(global.eventPersonLastName)
			global.personAges.append(global.eventPersonAge)
			global.personRelationships.append(randi_range(20, 50))
			global.personTypes.append("Friend")
			global.personCategories.append("misc")
			$option1.text = "Okay"
		optionRemover(2)
	elif global.revent[0] == "toddler-0-o1":
		$heading.text = "Nooo"
		if global.personTypes.has("Mother"): #if you have a mother
			$body.text = "She says no. You go home depressed and don't leave your room for 11 days.\n- 10 Joy" #mother-specific body text
		elif global.personTypes.has("Father"): #if you have a father
			$body.text = "He says no. You go home depressed and don't keave your room for 11 days.\n- 10 Joy" #father-specific body text
		$option1.text = "Okay"
		optionRemover(2)
		global.joy -= 10 #deducts 10 joy
	elif global.revent[0] == "child-0-o1":
		var relativeOfChoice = global.personRelationships.find(global.personRelationships.min()) #gets the index of the gifter
		$heading.text = "Wow... It's just... Wow."
		if global.evality < 30: #if evality is under 30, you feel bad about lying
			$body.text = "They appreciate your kind words, but you feel kind of bad about lying.\n+ 5 relationship with your " + str(global.personTypes[relativeOfChoice]) + ", " + str(global.personFirstNames[relativeOfChoice]) + ", - 5 Joy"
			global.joy -= 5
		else: #if evality is 30 or over, you don't feel bad
			$body.text = "They appreciate your kind words.\n+ 5 relationship with your " + str(global.personTypes[relativeOfChoice]).to_lower() + ", " + str(global.personFirstNames[relativeOfChoice])
		$option1.text = "Okay"
		optionRemover(2)
		global.personRelationships[relativeOfChoice] += 5 #adds 5 to the relationship you have with the gifter
		global.evality += 3 #since you did something semi-bad, you become slightly desensitised to doing bad things
	elif global.revent[0] == "change-save-management-mode-to-delete-o1":
		goToSpecific("res://pages/life_save_files.tscn")
	elif global.revent[0] == "university-degree-picked-o1":
		$heading.text = "Well educated"
		$body.text = "You are now enrolled in University for a degree in " + global.degreePicked + ".\n- $"
		if global.degreePicked == "education":
			global.money -= 25000 #pay the appropriate amount for university tuition
			$body.text += "25000"
		$option1.text = "Okay"
		optionRemover(2)
		global.schoolLevel = 3 #moves you up to tertiary schooling
		global.schoolName = global.lastNames[randi_range(0, global.lastNames.size() - 1)] #gives the university a random name
		match randi_range(1,3): #gives the university name a random appendix
			1:
				global.schoolName += " Academy"
			2:
				global.schoolName += " College"
			3:
				global.schoolName += " University"


func option2outcomes(): #option 2 has been picked
	if global.revent[0] == "toddler-friend-o2" || global.revent[0] == "child-friend-o2":
		$heading.text = "...Can you go away?"
		$body.text = "You ignore " + global.pronounGenerator("him", global.eventPersonSex) + " for a while, and eventually " + global.pronounGenerator("he", global.eventPersonSex) + " goes away."
		$option1.text = "Okay"
		optionRemover(2)
		global.evality += 4 #i mean, it was kind of rude...
	if global.revent[0] == "teenager-friend-o2":
		@warning_ignore("integer_division")
		if randi_range(1, round((36 - global.looks / 4) / 2) - 3) == 1: #if you're more physically attractive, you have a higher chance of being accepted
			$heading.text = "What's your number?"
			$body.text = "You ask " + global.pronounGenerator("him", global.eventPersonSex) + " out on a date, and " + global.pronounGenerator("he", global.eventPersonSex) + " says yes.\nJoy + 15"
			global.joy += 15
			#if you already have an S/O, break up with (removes) them
			for i in global.personTypes.size(): #runs through every non-familial relationship
				if global.personTypes[i] == "Boyfriend" || global.personTypes[i] == "Girlfriend": #and if they're your gf/bf
					personRemover(i) #removes them
				#for loops automatically increase the variable they use (in this case, i) so no need to manually increment it
			#adds them to your relationships
			global.miscFirstNames.append(global.eventPersonFirstName)
			global.miscLastNames.append(global.eventPersonLastName)
			global.personSexes.append(global.eventPersonSex)
			global.personAges.append(global.eventPersonAge)
			global.personRelationships.append(randi_range(40, 80))
			global.personTypes.append((global.pronounGenerator("boy", global.eventPersonSex) + "friend").capitalize())
			global.personCategories.append("misc")
		else: #they DON'T want to date you
			$heading.text = "..."
			$body.text = "You ask " + global.pronounGenerator("him", global.eventPersonSex) + " out, but " + global.pronounGenerator("he", global.eventPersonSex) + " rejects you.\nJoy - 15"
			global.joy -= 15
		$option1.text = "Okay"
		optionRemover(2)
	elif global.revent[0] == "adult-friend-o2":
		$heading.text = "You wanna go out sometime?"
		@warning_ignore("integer_division")
		if randi_range(1, round((36 - global.looks / 4) / 2) - 3) == 1: #if you're more physically attractive, you have a higher chance of being accepted
			$body.text = "You ask " + global.pronounGenerator("him", global.eventPersonSex) + " out on a date, and " + global.pronounGenerator("he", global.eventPersonSex) + " says yes.\nJoy + 15"
			global.joy += 15
			#if you already have an S/O, break up with (removes) them
			for i in global.personTypes.size(): #runs through every relationship
				if global.personTypes[i] == "Boyfriend" || global.personTypes[i] == "Girlfriend": #and if they're your gf/bf
					personRemover(i) #removes them
				#for loops automatically increase the variable they use (in this case, i) so no need to manually increment it
			#adds them to your relationships
			global.miscFirstNames.append(global.eventPersonFirstName)
			global.miscLastNames.append(global.eventPersonLastName)
			global.personSexes.append(global.eventPersonSex)
			global.personAges.append(global.eventPersonAge)
			global.personRelationships.append(randi_range(40, 80))
			global.personTypes.append((global.pronounGenerator("boy", global.eventPersonSex) + "friend").capitalize())
			global.personCategories.append("misc")
		else: #they DON'T want to date you
			$body.text = "You ask " + global.pronounGenerator("him", global.eventPersonSex) + " out, but " + global.pronounGenerator("he", global.eventPersonSex) + " rejects you.\nJoy - 15"
			global.joy -= 15
		$option1.text = "Okay"
		optionRemover(2)
	elif global.revent[0] == "elder-friend-o2":
		@warning_ignore("integer_division")
		if randi_range(1, round(36 - global.looks / 4) - 3) == 1: #if you're more physically attractive, you have a higher chance of being accepted. You have lower chances either way though since you're older.
			$heading.text = "Better late than never"
			$body.text = "You ask " + global.pronounGenerator("him", global.eventPersonSex) + " out on a date, and " + global.pronounGenerator("he", global.eventPersonSex) + " says yes.\nJoy + 15"
			global.joy += 15
			#if you already have an S/O, break up with (removes) them
			for i in global.personTypes.size(): #runs through every non-familial relationship
				if global.personTypes[i] == "Boyfriend" || global.personTypes[i] == "Girlfriend": #and if they're your gf/bf
					personRemover(i) #removes them
				#for loops automatically increase the variable they use (in this case, i) so no need to manually increment it
			#adds them to your relationships
			global.miscFirstNames.append(global.eventPersonFirstName)
			global.miscLastNames.append(global.eventPersonLastName)
			global.personSexes.append(global.eventPersonSex)
			global.personAges.append(global.eventPersonAge)
			global.personRelationships.append(randi_range(40, 80))
			global.personTypes.append((global.pronounGenerator("boy", global.eventPersonSex) + "friend").capitalize())
			global.personCategories.append("misc")
		else: #they DON'T want to date you
			$heading.text = str(global.age) + " and still unmarried"
			$body.text = "You ask " + global.pronounGenerator("him", global.eventPersonSex) + " out on a date, but " + global.pronounGenerator("he", global.eventPersonSex) + " rejects you.\nJoy - 15"
			global.joy -= 15
		$option1.text = "Okay"
		optionRemover(2)
	elif global.revent[0] == "toddler-0-o2":
		$heading.text = "You screamed for ice cream"
		if global.personTypes.has("Mother"):
			$body.text = "You cry, and eventually your mother gives in and buys you one.\nJoy + 5, relationship with mother -5"
			global.personRelationships[global.personTypes.find("Mother")] -= 5
		elif global.personTypes.has("Father"):
			$body.text = "You cry, and eventually your father gives in and buys you one.\nJoy + 5, relationship with father -5"
			global.personRelationships[global.personTypes.find("Father")] -= 5
		$option1.text = "Okay"
		optionRemover(2)
		global.joy += 5
		global.evality += 4
	elif global.revent[0] == "child-0-o2":
		var relativeOfChoice = global.personRelationships.find(global.personRelationships.min()) #gets the index of the gifter
		$heading.text = "Wow! It's just... Wow!"
		if global.evality < 40: #if evality is under 40, you feel bad about lying
			$body.text = "They appreciate your kind words, so much so that they surprise you with another $50, but you feel really bad about lying.\n+ 8 relationship with your " + str(global.personTypes[relativeOfChoice]).to_lower() + ", " + str(global.personFirstNames[relativeOfChoice]) + ", - 10 Joy, + $50"
			global.joy -= 10
		else: #if evality is 40 or above, you don't feel bad
			$body.text = "They appreciate your kind words, so much so that they surprise you with another $50.\n+ 8 relationship with your " + str(global.personTypes[relativeOfChoice]).to_lower() + ", " + str(global.personFirstNames[relativeOfChoice]) + ", + $50"
		$option1.text = "Okay"
		optionRemover(2)
		global.personRelationships[relativeOfChoice] += 8
		global.money += 50
		global.evality += 4 #since you did something bad, you become slightly desensitised to doing bad things
	elif global.revent[0] == "change-save-management-mode-to-delete-o2":
		goToSpecific("res://pages/life_save_files.tscn")
	elif global.revent[0] == "graduated-high-school-o2":
		goToSpecific("res://pages/university_pick_degree.tscn")
	elif global.revent[0] == "university-degree-picked-o2":
		var parent = 0
		var parentNoun = ""
		if global.personTypes.find("Mother") != -1: #if you have a mother
			parent = global.personTypes.find("Mother") #gets the index of said mother
		elif global.personTypes.find("Father") != -1: #if you have only a father
			parent = global.personTypes.find("Father") #gets the index of said father
		if global.personTypes.count("Mother") + global.personTypes.count("Father") >= 2: #if you have multiple parents
			parentNoun = "parents"
		elif global.personTypes.count("Mother") + global.personTypes.count("Father") == 1: #if you only have one parent
			if parent == "Mother": #if you have only a mother
				parentNoun = "mother"
			else: #if you only have a father
				parentNoun = "father"
		#if your parents actually do agree to pay for your tuition
		if global.personRelationships[parent] >= 60 && randi_range(1,2) == 1: #if you have a good relationship with your parents AND your parents actually agree to pay for your tuition (1 in 2 chance)
			$heading.text = "Nepo baby?"
			$body.text = "Your " + str(parentNoun) + " agreed to pay for your University tuition!"
			global.schoolLevel = 3 #puts you in tertiary school
			global.schoolName = global.lastNames[randi_range(0, global.lastNames.size() - 1)] #gives the university a random name
			match randi_range(1,3): #gives the university name a random appendix
				1:
					global.schoolName += " Academy"
				2:
					global.schoolName += " College"
				3:
					global.schoolName += " University"
		else: #if your parents refuse to pay for it
			$heading.text = "I guess you just don't love me then"
			$body.text = "Your " + str(parentNoun) + " refused to pay for your University tuition."
			global.revent[0] = "university-degree-picked-o2-refused" #this sends you back to the start of the original event asking how you would like to pay tuition, but with the option to ask your parents to pay disabled, since you already tried that and it didn't work
		$option1.text = "Okay"
		optionRemover(2)


func option3outcomes(): #option 3 has been picked
	if global.revent[0] == "teenager-friend-o3" || global.revent[0] == "adult-friend-o3" || global.revent[0] == "elder-friend-o3":
		if global.evality >= 60:
			$heading.text = "Can you go away"
			$body.text = "You stop talking to " + global.pronounGenerator("him", global.eventPersonSex) + " and " + global.pronounGenerator("he", global.eventPersonSex) + " eventually goes away."
			global.evality += 5
		else:
			$heading.text = "Alright, bye"
			$body.text = "You finish talking to " + global.pronounGenerator("him", global.eventPersonSex) + " and you go your seperate ways."
		$option1.text = "Okay"
		optionRemover(2)
	elif global.revent[0] == "toddler-0-o3":
		$heading.text = "If you insist"
		if global.personTypes.has("Mother"):
			$body.text = "Your mother points to the shop and asks you if you want to get one. You go on to have a great day out together.\nJoy + 10, relationship with mother + 10"
			global.personRelationships[global.personTypes.find("Mother")] += 10
		elif global.personTypes.has("Father"):
			$body.text = "Your father points to the shop and asks you if you want to get one. You go on to have a great day out together.\nJoy + 10, relationship with father + 10"
			global.personRelationships[global.personTypes.find("Father")] += 10
		$option1.text = "Okay"
		optionRemover(2)
		global.joy += 10
	elif global.revent[0] == "child-0-o3":
		var relativeOfChoice = global.personRelationships.find(global.personRelationships.min()) #gets the index of the gifter
		$heading.text = "Wow, this sucks"
		var parents = [] #indexes of all parents; size determines whether "parent" should be plural or not in the body text
		for i in global.personTypes.size(): #runs through every family member to check for parents
			if global.personTypes[i] == "Mother" || global.personTypes[i] == "Father": #if family member at the index we're checking is a parent
				parents.append(i)
		if parents.size() > 1: #if you have more than one parent
			$body.text = "Your parents scold you for being unappreciative.\n- 8 relationship with your " + global.personTypes[relativeOfChoice].to_lower() + ", " + global.personFirstNames[relativeOfChoice] + ", -8 relationship with your parents, - 12 Joy"
		else: #if you only have one parent
			#finds parent
			var whatParent = ""
			if global.parents.find("Mother") != -1: #if you have only a mother
				whatParent = "mother"
			elif global.parents.find("Father") != -1: #if you have only a father
				whatParent = "mather"
			$body.text = "Your " + whatParent + " scolds you for being unappreciative.\n- 8 relationship with your " + global.personTypes[relativeOfChoice].to_lower() + ", " + global.personFirstNames[relativeOfChoice] + ", -8 relationship with your " + whatParent + ", - 12 Joy"
		$option1.text = "Okay"
		optionRemover(2)
		global.personRelationships[relativeOfChoice] -= 8 #deduct 8 relationship with gifter
		for i in parents.size(): #runs through every parent
				global.personRelationships[parents[i]] -= 8 #deducts 8 relationship from the parent at the index of parents[i] (parents stores indexes, so the parents at position i in the parents array could have a different index to themself in the other family arrays.
		global.joy -= 12
	elif global.revent[0] == "university-degree-picked-o3":
		$heading.text = "Student loans"
		$body.text = "You took out a "
		if global.degreePicked == "education":
			$body.text += "$25,000 student loan that needs to be paid back over 20 years with an interest rate of 8%."
			global.loans.append(25000) #takes out the $25,000 loan
			global.loanInterest.append(8) #8% annual interest
			global.loanPaybackDuration.append(20) #pay it back over the course of 20 years
		$option1.text = "Okay"
		optionRemover(2)


func option4outcomes(): #option 4 has been picked
	if global.revent[0] == "child-0-o4":
		var relativeOfChoice = global.personRelationships.find(global.personRelationships.min()) #gets the index of the relative featured in this event
		$heading.text = "No one can ever know."
		$body.text = "You kill your " + global.personTypes[relativeOfChoice].to_lower() + " in cold blood. You push " + global.pronounGenerator("him", global.personSexes[relativeOfChoice]) + " down the stairs while no-one's looking.\n+ 100 Intellect"
		$option1.text = "Okay"
		optionRemover(2)
		#stat effects
		global.intellect = 100
		global.NPCKiller(relativeOfChoice) #kills uncle
		global.crimes.append("Second degree homicide")
		global.crimesSeverity.append(95)
	elif global.revent[0] == "university-degree-picked-o4":
		if global.schoolPerformance >= 80: #if you did really well at your last school (usually highschool, unless you're going for a second degree)
			$heading.text = "What a scholar"
			$body.text = "Your application for a scholarship was accepted!"
			global.schoolLevel = 3 #puts you in tertiary school
			global.schoolName = global.lastNames[randi_range(0, global.lastNames.size() - 1)] #gives the university a random name
			match randi_range(1,3): #gives the university name a random appendix
				1:
					global.schoolName += " Academy"
				2:
					global.schoolName += " College"
				3:
					global.schoolName += " University"
			$option1.text = "Hooray"
		else: #if your school performance isn't really good
			$heading.text = "NOT a scholar"
			$body.text = "Your application for a scholarship was rejected."
			global.revent[0] = "university-degree-picked-o4-rejected"
			$option1.text = "Okay"
		optionRemover(2)


func option5outcomes(): #option 5 has been picked
	pass


func eventer(): #runs all the functions
	toddlerhood()
	childhood()
	teenagehood()
	adulthood()
	elderhood()
	multiAgeRange()
	specialised()
	relationships()
	confirmation()
	option1outcomes()
	option2outcomes()
	option3outcomes()
	option4outcomes()
	option5outcomes()


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
