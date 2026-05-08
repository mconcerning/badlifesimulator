extends Node2D #author(s): Ethan Scott
#handles all events


func optionRemover(optionXOnwards): #disables and changes the opacity to 0 of unused buttons (optionXOnwards is the button you want to disable. It and every button below it will be disabled)
	$cancelEvent.queue_free() #having options means there is an event, which means you can't softlock your life by being here unless the options do nothing. nonetheless, you don't need this now.
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
	$heading.position.x = round(540 - (float($heading.size.x / 2))) #centres heading text horizontally on the screen
	$body.position.x = round(540 - (float($body.size.x / 2)))
	$option1.position.x = round(540 - (float($option1.size.x / 2))) #centres button horizontally on the screen
	$option2.position.x = round(540 - (float($option2.size.x / 2)))
	$option3.position.x = round(540 - (float($option3.size.x / 2)))
	$option4.position.x = round(540 - (float($option4.size.x / 2)))
	$option5.position.x = round(540 - (float($option5.size.x / 2)))


func outcome(reventID):
	global.revent[0] = reventID
	await get_tree().process_frame
	get_tree().reload_current_scene()


func goHome():
	global.revent.pop_front()
	await get_tree().process_frame
	get_tree().change_scene_to_file("res://pages/game_menu.tscn")


func goToPrison(): #you need to manually set prisonSentence and do everything else
	global.revent.pop_front()
	await get_tree().process_frame
	get_tree().change_scene_to_file("res://pages/prison.tscn")


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
			$body.text = "While out and about with your " + str(global.personTypes[0]).to_lower() + ", you strike up a conversation with a random kid and you two seem to get along pretty well.\n("
		else: #random body text variation
			$body.text = "While out and about with your " + str(global.personTypes[0]).to_lower() + ", you strike up a conversation with a random kid and you two seem to get along pretty well.\n("
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
		global.history.append("compliment-relationship-" + str(global.personUIDs[global.IDClicked]))
		var badCompliments = ["racist", "a tangerine"]
		var possibleCompliments = ["really cool", "incredibly attractive", "talented", "fun to be around", "kind", "productive", "intelligent", "smart", "energetic", "creative", "interesting", "a hero", "the best"]
		if global.personCategories[global.IDClicked] == "family": #if they are a family member
			possibleCompliments.pop_at(possibleCompliments.find("incredibly attractive"))
			badCompliments.append("incredibly attractive") #calling them hot is now negative
		var complimentSelected = possibleCompliments[randi_range(0, possibleCompliments.size() - 1)] #picks a compliment to give
		if randi_range(1, max(1, roundi(float(global.intellect) / 2))) == 1: #if you accidently forget to compliment them (higher change if you're less intelligent)
			complimentSelected = badCompliments[randi_range(0, badCompliments.size() - 1)] #picks a "compliment" to give
		if global.cooldown("compliment-relationship-" + str(global.personUIDs[global.IDClicked])) >= 3: #if you've complimented them too much recently
			$heading.text = "Whatever you say"
			$body.text = "Your " + global.personTypes[global.IDClicked].to_lower() + ", " + global.personFirstNames[global.IDClicked] + ", said " + global.pronounGenerator("he", global.personSexes[global.IDClicked]) + "'s sick of you trying to compliment " + global.pronounGenerator("him", global.personSexes[global.IDClicked]) + " so much and you need to calm down."
		else: #if you haven't complimented them 3 or more times already this year
			global.XPQueued += 3
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


func prison(): #specialised prison events
	push_warning("you should probably finish all the prison() events")
	if global.revent[0] == "arrested" || global.revent[0] == "court-trial-o2-failed-o1": #"arrested" when you encounter police randomly, "arrested-caught" when you get caught in the middle of committing a crime.
		$heading.text = "Long arm of the law"
		if global.sumCalculator(global.crimesSeverity) >= 200:
			$body.text = "While at home, a barrage of uniformed officers break down your door and run inside."
			$option2.text = "Surrender arrest"
		elif global.sumCalculator(global.crimesSeverity) >= 50 && global.sumCalculator(global.crimesSeverity) < 200:
			$body.text = "While out in public, a group of uniformed police officers approach you and start asking questions."
			$option2.text = "Confess"
		elif global.sumCalculator(global.crimesSeverity) >= 10 && global.sumCalculator(global.crimesSeverity) < 50:
			$body.text = "While out in public, a police officer approaches you and starts asking questions."
			$option2.text = "Confess"
		else:
			goHome()
		$option1.text = "Try to flee"
		optionRemover(3)
	elif global.revent[0] == "pre-court-trial-o1" || global.revent[0] == "court-trial" || global.revent[0] == "arrested-o2": #they are identical, but one is assigned directly and the other two are assigned as a result of choosing an option in another event ("arrested-o1" & "arrested" respectively)
		$heading.text = "Court trial"
		global.revent[0] = "court-trial"
		var crimesDeduplicated = []
		var crimesCount = []
		for i in global.crimes.size(): #runs through all your crimes
			if crimesDeduplicated.find(global.crimes[i]) != -1: #if this specific crime is already in the deduplicated array
				crimesCount[crimesDeduplicated.find(global.crimes[i])] += 1 #it has appeared once more
			else: #if it has not appeared in the deduplicated array
				crimesDeduplicated.append(global.crimes[i])
				crimesCount.append(1) #appeared for the very first time
		$body.text = "You are being charged with "
		for i in crimesDeduplicated.size(): #runs through all your unique crimes (duplicates removed)
			var countCountsText = ""
			if crimesCount[i] == 1:
				countCountsText = "count"
			else:
				countCountsText = "counts"
			if crimesDeduplicated.size() >= 2:
				if i == crimesDeduplicated.size() - 1: #if this is the last one
					if crimesDeduplicated.size() >= 3: #if there's at least 3 crimes, use oxford comma
						$body.text += ", "
					elif crimesDeduplicated.size() == 2: #if there's not, don't
						$body.text += " "
					$body.text += "and " + str(crimesCount[i]) + " " + countCountsText + " of " + crimesDeduplicated[i] + "." #append the rest
				elif i != 0 && i <= crimesDeduplicated.size() - 2: #if this is between the first one and second-last one (not applicable if size is under 3)
					$body.text += ", " + str(crimesCount[i]) + " " + countCountsText + " of " + crimesDeduplicated[i]
			if i == 0: #if this is the first one (applicable even if size is 1)
				$body.text += str(crimesCount[i]) + " " + countCountsText + " of " + crimesDeduplicated[i]
				if crimesDeduplicated.size() == 1:
					$body.text += "."
		$option1.text = "Go to court"
		$option2.text = "Don't go to court"
		optionRemover(3)
	elif global.revent[0] == "court-trial-o1" || global.revent[0] == "court-trial-o2-prison-o1":
		global.revent[0] = "court-trial-lawyer-pick"
		$heading.text = "Court trial"
		var totalSentence = global.crimeTimeCalculator()
		if totalSentence is int: #if you're not facing life in prison
			totalSentence = str(totalSentence) + " years"
		$body.text = "You are facing up to " + totalSentence + " in prison for your "
		if global.crimes.size() == 1: #if you've only ever committed one crime
			$body.text += "crime."
		else:
			$body.text += str(global.crimes.size()) + " crimes."
		$body.text += "\n\nWould you like to pick a lawyer to represent you in court?"
		$option1.text = "I am my own lawyer"
		$option2.text = "Public defender ($0)"
		$option3.text = global.lawyers[0] + " ($" + str(global.sumCalculator(global.crimesSeverity) * global.lawyerCostMultiplier[0]) + ")"
		if global.money < global.sumCalculator(global.crimesSeverity) * global.lawyerCostMultiplier[0]:
			$option3.disabled = true
		$option4.text = global.lawyers[1] + " ($" + str(global.sumCalculator(global.crimesSeverity) * global.lawyerCostMultiplier[1]) + ")"
		if global.money < global.sumCalculator(global.crimesSeverity) * global.lawyerCostMultiplier[1]:
			$option4.disabled = true
		$option5.text = global.lawyers[2] + " ($" + str(global.sumCalculator(global.crimesSeverity) * global.lawyerCostMultiplier[2]) + ")"
		if global.money < global.sumCalculator(global.crimesSeverity) * global.lawyerCostMultiplier[2]:
			$option5.disabled = true
		optionRemover(6)
	elif global.revent[0] == "court-trial-lawyer-pick-o1" || global.revent[0] == "court-trial-lawyer-pick-o2" || global.revent[0] == "court-trial-lawyer-pick-o3" || global.revent[0] == "court-trial-lawyer-pick-o4" || global.revent[0] == "court-trial-lawyer-pick-o5":
		match global.revent[0]:
			"court-trial-lawyer-pick-o1":
				if global.degrees.find("Law") == -1: #if you are NOT qualified to be a lawyer
					$heading.text = "I know some laws"
				else: #if you ARE qualified to be a lawyer
					$heading.text = "Slight conflict of interest"
				$body.text = "You chose yourself to represent you in court."
				global.revent[0] = "court-trial-o1-results"
			"court-trial-lawyer-pick-o2":
				$heading.text = "Bottom-notch"
				$body.text = "You chose a public defender to represent you in court."
				global.revent[0] = "court-trial-o2-results"
			"court-trial-lawyer-pick-o3":
				$heading.text = "External representation"
				$body.text = "You chose " + global.lawyers[0] + " to represent you in court for $" + str(global.sumCalculator(global.crimesSeverity) * global.lawyerCostMultiplier[0]) + "."
				global.money -= global.sumCalculator(global.crimesSeverity) * global.lawyerCostMultiplier[0]
				global.revent[0] = "court-trial-o3-results"
			"court-trial-lawyer-pick-o4":
				$heading.text = "External representation"
				$body.text = "You chose " + global.lawyers[1] + " to represent you in court for $" + str(global.sumCalculator(global.crimesSeverity) * global.lawyerCostMultiplier[1]) + "."
				global.money -= global.sumCalculator(global.crimesSeverity) * global.lawyerCostMultiplier[1]
				global.revent[0] = "court-trial-o4-results"
			"court-trial-lawyer-pick-o5":
				$heading.text = "Top-notch"
				$body.text = "You chose " + global.lawyers[2] + " to represent you in court for $" + str(global.sumCalculator(global.crimesSeverity) * global.lawyerCostMultiplier[2]) + "."
				global.money -= global.sumCalculator(global.crimesSeverity) * global.lawyerCostMultiplier[2]
				global.revent[0] = "court-trial-o5-results"
		$body.text += "\n\nYou have the opportunity to plead guilty or not guilty before the judge. If you plead guilty, there's a chance you can get a lower sentence."
		$option1.text = "Guilty"
		$option2.text = "Not guilty"
		optionRemover(3)
	elif global.revent[0] == "court-trial-o1-results-o1" || global.revent[0] == "court-trial-o2-results-o1" || global.revent[0] == "court-trial-o3-results-o1" || global.revent[0] == "court-trial-o4-results-o1" || global.revent[0] == "court-trial-o5-results-o1": #plead guilty
		$body.text = "You pleaded guilty to all charges.\n\n"
		$option1.text = "Okay"
		global.revent[0] = "go-to-prison"
		match global.revent[0]:
			"court-trial-o1-results-o1": #self-defence
				$heading.text = "Putting the I in guilty"
				if global.degrees.find("Law") == -1: #if you are NOT a qualified lawyer
					if global.intellect >= 95 && global.sumCalculator(global.crimesSeverity) <= global.intellect:
						if global.crimeTimeCalculator() is int && global.crimeTimeCalculator() > 1:
							var sentenceLoweredBy = randi_range(1, min(3, global.crimeTimeCalculator() - 1)) #lowers your potential sentence
							$body.text += "Even though you don't have a law degree, you successfully managed to lower your sentence by " + sentenceLoweredBy + "year"
							if sentenceLoweredBy > 1:
								$body.text += "s"
							$body.text += "."
							global.prisonPreparer(global.crimeTimeCalculator() - sentenceLoweredBy)
							global.revent[0] = "go-to-prison"
						elif global.crimeTimeCalculator() == 1:
							var fine = randi_range(25, max(28, global.sumCalculator(global.criminalRecordSeverity))) * 100
							$body.text += "Since you were only facing a potential 1-year prison sentence, you managed to talk it down to a $" + str(fine) + " fine."
							global.money -= fine
							global.revent[0] = "dont-go-to-prison"
							for i in global.crimes.size():
								global.criminalRecord.append(global.crimes[i])
								global.criminalRecordSeverity.append(global.crimesSeverity[i])
							global.crimes = []
							global.crimesSeverity = []
							global.crimeTime = []
							global.intellectAtTimeOfCrime = []
						elif global.crimeTimeCalculator() == "Life":
							var newSentence = max(40, global.sumCalculator(global.crimeTime))
							$body.text += "You managed to talk down your Life sentence to a " + str(newSentence) + " year sentence."
							global.prisonPreparer(newSentence)
					else: #if you are NOT good enough to win AND you're not a qualified lawyer
						$body.text += "You failed to negotiate a lower sentence for yourself and have been sentenced to "
						if str(global.crimeTimeCalculator()) == "Life":
							$body.text += "Life"
						elif global.crimeTimeCalculator() is int:
							$body.text += str(global.crimeTimeCalculator()) + " years"
						$body.text += " in prison."
						global.prisonPreparer(global.prisonSentence)
				elif global.degrees.find("Law") != -1: #if you ARE a qualified lawyer
					pass
	elif global.revent[0] == "court-trial-o1-results-o2" || global.revent[0] == "court-trial-o2-results-o2" || global.revent[0] == "court-trial-o3-results-o2" || global.revent[0] == "court-trial-o4-results-o2" || global.revent[0] == "court-trial-o5-results-o2": #plead not guilty
		match global.revent[0]:
			"court-trial-o1-results-o2": #self-defence
				if global.degrees.find("Law") == -1: #if you are NOT a qualified lawyer
					if global.intellect >= 95 && global.sumCalculator(global.crimesSeverity) <= global.intellect:
						$heading.text = "And everybody clapped"
						$body.text = "Even though you don't have a law degree, you managed to successfully defend yourself in court and have been found not guilty of all charges."
						$option1.text = "Awesome"
						global.crimes = [] #no more crimes, you're free to go
						global.crimesSeverity = []
						global.crimeTime = []
						global.intellectAtTimeOfCrime = []
						global.revent[0] = "dont-go-to-prison"
					else:
						$heading.text = "Being a lawyer is all about big speeches"
						$body.text = "You couldn't manage to properly defend yourself in court. You have been sentenced to "
						if str(global.crimeTimeCalculator()) == "Life":
							$body.text += "Life"
						elif global.crimeTimeCalculator() is int:
							$body.text += str(global.crimeTimeCalculator()) + " years"
						$body.text += " in prison."
						$option1.text = "Dang it"
						global.prisonPreparer(global.crimeTimeCalculator())
						global.revent[0] = "go-to-prison"
				else: #if you ARE a qualified lawyer
					if (global.degreeProficiency[global.degrees.find("Law")] >= max(global.crimesSeverity) - randi_range(1, 15) && global.intellect >= max(60, global.averageFinder(global.intellectAtTimeOfCrime)) && global.sumCalculator(global.crimesSeverity) <= 400) || randi_range(1, 25) == 1: #if your proficiency is greater than the severity of your worst crime, and you're smarter than you were when you committed most of your crimes, AND you're not some super-criminal. There is a small (1 in 25) chance you win even if you don't meet these requirements.
						$heading.text = "Self-defence GOAT"
						$body.text = "You successfully represented yourself in court and have been found not guilty of all charges."
						$option1.text = "Awesome"
						global.crimes = [] #no more crimes, you're free to go
						global.crimesSeverity = []
						global.crimeTime = []
						global.intellectAtTimeOfCrime = []
						global.revent[0] = "dont-go-to-prison"
					else: #if you're a qualified lawyer but you still failed
						$heading.text = "YOU let you down"
						$body.text = "Even though you have a law degree, you failed to clear your name in court. You have been sentenced to "
						if str(global.crimeTimeCalculator()) == "Life":
							$body.text += "Life"
						elif global.crimeTimeCalculator() is int:
							$body.text += str(global.crimeTimeCalculator()) + " years"
						$body.text += " in prison."
						$option1.text = "Dang it"
						global.prisonPreparer(global.crimeTimeCalculator())
						global.revent[0] = "go-to-prison"
			"court-trial-o2-results-o2": #public defender
				if (randi_range(25, 50) >= global.sumCalculator(global.crimesSeverity) && randi_range(75, 95) <= global.averageFinder(global.intellectAtTimeOfCrime)) || randi_range(1, 25) == 1: #if your public defender is successful in publicly defending you. i.e. if you are a) NOT a very severe criminal, and b) were VERY intelligent when you committed your crime(s). 1 in 25 chance you win even if you don't meet these requirements.
					if global.crimes.find("Tax evasion") == -1: #if you don't evade your taxes
						$heading.text = "I'm so glad I paid taxes"
					else: #if you HAVE committed tax evasion
						$heading.text = "I'm glad SOMEONE was paying taxes"
					$body.text = "Your public defender successfully cleared your name in court. You have been found not guilty of all charges."
					$option1.text = "Hooray"
					global.crimes = [] #no more crimes, you're free to go
					global.crimesSeverity = []
					global.crimeTime = []
					global.intellectAtTimeOfCrime = []
					global.revent[0] = "dont-go-to-prison"
				else: #if your public defender sucks
					$heading.text = "Great use of taxpayer money"
					$body.text = "Your public defender failed to clear your name in court. You have been found guilty of all charges and are being sentenced to "
					if str(global.crimeTimeCalculator()) == "Life":
						$body.text += "Life"
					elif global.crimeTimeCalculator() is int:
						$body.text += str(global.crimeTimeCalculator()) + " years"
					$body.text += " in prison."
					$option1.text = "Dang it"
					global.prisonPreparer(global.crimeTimeCalculator())
					global.revent[0] = "go-to-prison"
			"court-trial-o3-results-o2":
				if (randi_range(40, 55) >= global.sumCalculator(global.crimesSeverity) && randi_range(60, 70) <= global.averageFinder(global.intellectAtTimeOfCrime)) || randi_range(1, 20) == 1: #defence success - see public defender. Basically the same formula, just with some variables changed to give you better chances.
					$heading.text = "$3 an hour well spent"
					$body.text = global.lawyers[0] + ", a tier 1 lawyer, successfully cleared your name in court. You have been found not guilty of all charges."
					$option1.text = "Sweet"
					global.crimes = [] #no more crimes, you're free to go
					global.crimesSeverity = []
					global.crimeTime = []
					global.intellectAtTimeOfCrime = []
					global.revent[0] = "dont-go-to-prison"
				else: #defence failure
					$heading.text = "A penny saved is a penny earned, and I will be earning no pennies in prison"
					$body.text = global.lawyers[0] + ", a tier 1 lawyer, failed to clear your name in court. You have been found guilty of all charges and are being sentenced to "
					if str(global.crimeTimeCalculator()) == "Life":
						$body.text += "Life"
					elif global.crimeTimeCalculator() is int:
						$body.text += str(global.crimeTimeCalculator()) + " years"
					$body.text += " in prison."
					$option1.text = "Dang it"
					global.prisonPreparer(global.crimeTimeCalculator())
					global.revent[0] = "go-to-prison"
			"court-trial-o4-results-o2":
				if (randi_range(80, 150) >= global.sumCalculator(global.crimesSeverity) && randi_range(40, 50) <= global.averageFinder(global.intellectAtTimeOfCrime)) || randi_range(1, 14) == 1: #defence success - see public defender. Basically the same formula, just with some variables changed to give you better chances.
					$heading.text = "Money well spent"
					$body.text = global.lawyers[1] + ", a tier 2 lawyer, successfully cleared your name in court. You have been found not guilty of all charges."
					$option1.text = "Incredible"
					global.crimes = [] #no more crimes, you're free to go
					global.crimesSeverity = []
					global.crimeTime = []
					global.intellectAtTimeOfCrime = []
					global.revent[0] = "dont-go-to-prison"
				else: #defence failed
					$heading.text = "Whatever, I didn't even want to be found not guilty anyway"
					$body.text = global.lawyers[1] + ", a tier 2 lawyer, failed to clear your name in court. You have been found guilty of all charges and are being sentenced to "
					if str(global.crimeTimeCalculator()) == "Life":
						$body.text += "Life"
					elif global.crimeTimeCalculator() is int:
						$body.text += str(global.crimeTimeCalculator()) + " years"
					$body.text += " in prison."
					$option1.text = "Dang it"
					global.prisonPreparer(global.crimeTimeCalculator())
					global.revent[0] = "go-to-prison"
			"court-trial-o5-results-o2":
				if (randi_range(150, 350) >= global.sumCalculator(global.crimesSeverity) && randi_range(25, 40) <= global.averageFinder(global.intellectAtTimeOfCrime)) || randi_range(1, 7) == 1: #defence success - see public defender. Basically the same formula, just with some variables changed to give you better chances.
					$heading.text = "It's only expensive if you lose"
					if (randi_range(25, 50) >= global.sumCalculator(global.crimesSeverity) && randi_range(75, 95) <= global.averageFinder(global.intellectAtTimeOfCrime)) || randi_range(1, 25) == 1: #if your crimes were already so minor that a public defender could have resolved them
						$heading.text = "Perhaps I went a little bit overboard"
					$body.text = global.lawyers[2] + ", a tier 3 lawyer, successfully cleared your name in court. You have been found not guilty of all charges."
					$option1.text = "Amazing"
					global.crimes = [] #no more crimes, you're free to go
					global.crimesSeverity = []
					global.crimeTime = []
					global.intellectAtTimeOfCrime = []
					global.revent[0] = "dont-go-to-prison"
				else: #defence failed
					$heading.text = "What the hell am I paying YOU for?"
					$body.text = global.lawyers[2] + ", a tier 3 lawyer, failed to clear your name in court, despite costing $" + str(global.sumCalculator(global.crimesSeverity) * global.lawyerCostMultiplier[2]) + ". You have been found guilty of all charges and are being sentenced to "
					if str(global.crimeTimeCalculator()) == "Life":
						$body.text += "Life"
					elif global.crimeTimeCalculator() is int:
						$body.text += str(global.crimeTimeCalculator()) + " years"
					$body.text += " in prison."
					$option1.text = "WHAT"
					global.prisonPreparer(global.crimeTimeCalculator())
					global.revent[0] = "go-to-prison"
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
		var dudStudyChance = roundi(float(global.intellect) / 2)
		if global.intellect <= 20: #if you're so intelligent that you're more inclined to have a total dud of a study session
			dudStudyChance = dudStudyChance / 4 #increases your chance of having a poor study session
		if randi_range(1, max(1, dudStudyChance)) == 1 || global.cooldown("study-harder") >= 3: #if you had a total dud of a study session; happens either at random (higher chance if you're less intelligent) or if you've already studied 3 or more times this year (you're burned out)
			match randi_range(1,2): #random heading text variation
				1:
					$heading.text = "What"
				2:
					$heading.text = "Huh"
			$body.text = "You tried to study for " + str(randi_range(2, 6)) + " hours, but absorbed next to no information."
			var joySubtracted = randi_range(3, 10)
			if global.cooldown("study-harder") >= 4: #if you've tried studying WAY too many times now
				var intellectGained = randi_range(3, 5)
				global.intellect += intellectGained
				$body.text += "\n+ " + str(intellectGained) + " Intellect, - " + str(joySubtracted) + " Joy"
			else:
				$body.text += "\n- " + str(joySubtracted) + " Joy"
			$option1.text = "Okay"
			optionRemover(2)
			global.joy -= joySubtracted
			global.history.append("study-harder")
		else:
			$heading.text = "Hunkering "
			match randi_range(1, 4): #random heading text variation
				1:
					$heading.text += "down"
				2:
					$heading.text += "through"
				3:
					$heading.text += "left"
				4:
					$heading.text += "in"
			var joySubtracted = randi_range(roundi(float(global.intellect)/10), 14 - roundi(float(global.intellect)/10))
			$body.text = "You studied for " + str(max(2, int(roundi(float(global.intellect)/20)))) + " hours.\n+ " + str(int(roundi(float(global.intellect)/7))) + " school performance, + " + str(int(roundi(float(global.intellect)/12)) + 2) + " Intellect, - " + str(joySubtracted) + " Joy"
			global.schoolPerformance += roundi(float(global.intellect)/7)
			global.intellect += roundi(float(global.intellect)/12) + 2
			global.joy -= joySubtracted
			global.history.append("study-harder")
			$option1.text = "Okay"
			optionRemover(2)
			global.XPQueued += 2
	elif global.revent[0] == "skip-class":
		global.history.append("skip-class")
		if global.cooldown("skip-class") >= randi_range(3, 4):
			$heading.text = "Whoops"
			$body.text = "You failed one of your classes after not attending for so long."
			var classPerformanceDeducted = randi_range(7, 9)
			var joyDeducted = randi_range(5, 11)
			global.schoolPerformance -= classPerformanceDeducted
			global.joy -= joyDeducted
			$body.text += "\n- " + str(classPerformanceDeducted) + " performance, - " + str(joyDeducted) + " joy"
		else:
			$heading.text = "Skipping class"
			const skippedClassTo = ["go bowling", "go skateboarding", "get lunch", "get ice cream", "go to the movie theatre", "go shopping"]
			$body.text = "You skipped class to " + skippedClassTo[randi_range(0, skippedClassTo.size() - 1)] + " instead."
			var classPerformanceDeducted = randi_range(7, 9)
			var intellectDeducted = randi_range(3, 4)
			var joyGained = randi_range(5, 11)
			global.schoolPerformance -= classPerformanceDeducted
			global.intellect -= intellectDeducted
			global.joy += joyGained
			$body.text += "\n- " + str(classPerformanceDeducted) + " performance, - " + str(intellectDeducted) + " intellect, + " + str(joyGained) + " joy"
		global.XPQueued += 3
		$option1.text = "Okay"
		optionRemover(2)


func _on_option_1_pressed() -> void: #on option 1 selected
	#confirmation - option 1 will be the only button available when the event's purpose is only to display information. Generally, the button will say "Okay".
	if global.revent[0] == "toddler-0-o1" || global.revent[0] == "toddler-0-o2" || global.revent[0] == "toddler-0-o3" || global.revent[0] == "child-0-o1" || global.revent[0] == "child-0-o2" || global.revent[0] == "child-0-o3" || global.revent[0] == "child-0-o4" || global.revent[0] == "toddler-friend-o1" || global.revent[0] == "toddler-friend-o2" || global.revent[0] == "child-friend-o1" || global.revent[0] == "child-friend-o2" || global.revent[0] == "teenager-friend-o1" || global.revent[0] == "teenager-friend-o2" || global.revent[0] == "teenager-friend-o3" || global.revent[0] == "adult-friend-o1" || global.revent[0] == "adult-friend-o2" || global.revent[0] == "adult-friend-o3" || global.revent[0] == "elder-friend-o1" || global.revent[0] == "elder-friend-o2" || global.revent[0] == "elder-friend-o3" || global.revent[0] == "child-labour-is-outlawed" || global.revent[0] == "enrolled-in-primary-school" || global.revent[0] == "enrolled-in-high-school" || global.revent[0] == "graduated-high-school" || global.revent[0] == "study-harder" || global.revent[0] == "university-degree-picked-o1" || global.revent[0] == "university-degree-picked-o2" || global.revent[0] == "university-degree-picked-o3" || global.revent[0] == "university-degree-picked-o4" || global.revent[0] == "university-degree-picked-o2" || global.revent[0] == "graduated-university" || global.revent[0] == "compliment-relationship" || global.revent[0] == "skip-class" || global.revent[0] == "arrested-o1-success" || global.revent[0] == "court-trial-o2" || global.revent[0] == "dont-go-to-prison":
		goHome()
	#special exceptions
	elif global.revent[0] == "go-to-prison":
		goToPrison() #sends you to prison
	elif global.revent[0] == "arrested-o1-curb":
		get_tree().change_scene_to_file("res://pages/death.tscn") #kills you
	#event - option 1 will be an actual option
	else:
		outcome(global.revent[0] + "-o1")


func _on_option_2_pressed() -> void: #on option 2 selected
	outcome(global.revent[0] + "-o2")


func _on_option_3_pressed() -> void: #on option 3 selected
	outcome(global.revent[0] + "-o3")


func _on_option_4_pressed() -> void: #on option 4 selected
	outcome(global.revent[0] + "-o4")


func _on_option_5_pressed() -> void: #on option 5 selected
	outcome(global.revent[0] + "-o5")


func option1outcomes(): #option 1 has been picked
	if global.revent[0] == "toddler-friend-o1" || global.revent[0] == "child-friend-o1":
		$heading.text = "Yay"
		$body.text = "You befriended " + global.eventPersonFirstName + " " + global.eventPersonLastName + "!"
		$option1.text = "Hooray"
		optionRemover(2)
		#adds the EGP to your relationships array
		global.NPCCreator(global.eventPersonSex, global.eventPersonFirstName, global.eventPersonLastName, global.eventPersonAge, randi_range(20, 50), "Friend", "misc", "random")
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
			global.personFirstNames.append(global.eventPersonFirstName)
			global.personLastNames.append(global.eventPersonLastName)
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
			global.NPCCreator(global.eventPersonSex, global.eventPersonFirstName, global.eventPersonLastName, global.eventPersonAge, randi_range(20, 50), "Friend", "misc", "random")
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
		global.XPQueued += 50
		global.schoolLevel = 3 #moves you up to tertiary schooling
		global.schoolName = global.lastNames[randi_range(0, global.lastNames.size() - 1)] #gives the university a random name
		match randi_range(1,3): #gives the university name a random appendix
			1:
				global.schoolName += " Academy"
			2:
				global.schoolName += " College"
			3:
				global.schoolName += " University"
	elif global.revent[0] == "arrested-o1":
		if global.health >= randi_range(65, 85) && randi_range(1,2) == 1:
			$heading.text = "Short arm of the law"
			$body.text = "You managed to run and escape from the police!"
			global.revent[0] = "arrested-o1-success"
		elif global.health > 1:
			$heading.text = "Whoops"
			$body.text = "You attempt to escape, but you get tackled and placed under arrest."
			global.revent[0] = "pre-court-trial"
		else: #if your health is ONE (or zero)
			$heading.text = "Aw man"
			$body.text = "You tried to escape, but on the way, you tripped on a curb and fell over."
			global.revent[0] = "arrested-o1-curb"
			global.causeOfDeath = "You died of blood loss and subsequent shock after a devastating accident."
		global.commitCrime("Evading arrest", roundi(float(global.sumCalculator(global.crimesSeverity)) / 3), max(1, roundi(float(global.sumCalculator(global.crimesSeverity) / 12)))) #how much time you have to do for evading arrest depends on how severe your other crimes are
		print(global.crimesSeverity)
		print(global.crimeTime)
		$option1.text = "Okay"
		optionRemover(2)


func option2outcomes(): #option 2 has been picked
	if global.revent[0] == "toddler-friend-o2" || global.revent[0] == "child-friend-o2":
		$heading.text = "...Can you go away?"
		$body.text = "You ignore " + global.pronounGenerator("him", global.eventPersonSex) + " for a while, and eventually " + global.pronounGenerator("he", global.eventPersonSex) + " goes away."
		$option1.text = "Okay"
		optionRemover(2)
		global.evality += 4 #i mean, it was kind of rude...
	if global.revent[0] == "teenager-friend-o2":
		if randi_range(1, round((36 - float(global.looks) / 4) / 2) - 3) == 1: #if you're more physically attractive, you have a higher chance of being accepted
			$heading.text = "What's your number?"
			$body.text = "You ask " + global.pronounGenerator("him", global.eventPersonSex) + " out on a date, and " + global.pronounGenerator("he", global.eventPersonSex) + " says yes.\nJoy + 15"
			global.joy += 15
			#if you already have an S/O, break up with (removes) them
			for i in global.personTypes.size(): #runs through every non-familial relationship
				if global.personTypes[i] == "Boyfriend" || global.personTypes[i] == "Girlfriend": #and if they're your gf/bf
					global.NPCKiller("remove", i) #removes them
				#for loops automatically increase the variable they use (in this case, i) so no need to manually increment it
			#adds them to your relationships
			global.NPCCreator(global.eventPersonSex, global.eventPersonFirstName, global.eventPersonLastName, global.eventPersonAge, randi_range(20, 50), global.pronounGenerator("boy", global.eventPersonSex).capitalize() + "friend", "misc", "random")
		else: #they DON'T want to date you
			$heading.text = "..."
			$body.text = "You ask " + global.pronounGenerator("him", global.eventPersonSex) + " out, but " + global.pronounGenerator("he", global.eventPersonSex) + " rejects you.\nJoy - 15"
			global.joy -= 15
		$option1.text = "Okay"
		optionRemover(2)
	elif global.revent[0] == "adult-friend-o2":
		$heading.text = "You wanna go out sometime?"
		if randi_range(1, round((36 - float(global.looks) / 4) / 2) - 3) == 1: #if you're more physically attractive, you have a higher chance of being accepted
			$body.text = "You ask " + global.pronounGenerator("him", global.eventPersonSex) + " out on a date, and " + global.pronounGenerator("he", global.eventPersonSex) + " says yes.\nJoy + 15"
			global.joy += 15
			#if you already have an S/O, break up with (removes) them
			for i in global.personTypes.size(): #runs through every relationship
				if global.personTypes[i] == "Boyfriend" || global.personTypes[i] == "Girlfriend": #and if they're your gf/bf
					global.NPCKiller("remove", i) #removes them
				#for loops automatically increase the variable they use (in this case, i) so no need to manually increment it
			#adds them to your relationships
			global.NPCCreator(global.eventPersonSex, global.eventPersonFirstName, global.eventPersonLastName, global.eventPersonAge, randi_range(40, 80), global.pronounGenerator("boy", global.eventPersonSex).capitalize() + "friend", "misc", "random")
		else: #they DON'T want to date you
			$body.text = "You ask " + global.pronounGenerator("him", global.eventPersonSex) + " out, but " + global.pronounGenerator("he", global.eventPersonSex) + " rejects you.\nJoy - 15"
			global.joy -= 15
		$option1.text = "Okay"
		optionRemover(2)
	elif global.revent[0] == "elder-friend-o2":
		if randi_range(1, round(36 - float(global.looks) / 4) - 3) == 1: #if you're more physically attractive, you have a higher chance of being accepted. You have lower chances either way though since you're older.
			$heading.text = "Better late than never"
			$body.text = "You ask " + global.pronounGenerator("him", global.eventPersonSex) + " out on a date, and " + global.pronounGenerator("he", global.eventPersonSex) + " says yes.\nJoy + 15"
			global.joy += 15
			#if you already have an S/O, break up with (removes) them
			for i in global.personTypes.size(): #runs through every non-familial relationship
				if global.personTypes[i] == "Boyfriend" || global.personTypes[i] == "Girlfriend": #and if they're your gf/bf
					global.NPCKiller("remove", i) #removes them
				#for loops automatically increase the variable they use (in this case, i) so no need to manually increment it
			#adds them to your relationships
			global.NPCCreator(global.eventPersonSex, global.eventPersonFirstName, global.eventPersonLastName, global.eventPersonAge, randi_range(20, 50), global.pronounGenerator("boy", global.eventPersonSex).capitalize() + "friend", "misc", "random")
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
			global.XPQueued += 40
		else: #if your parents refuse to pay for it
			$heading.text = "I guess you just don't love me then"
			$body.text = "Your " + str(parentNoun) + " refused to pay for your University tuition."
			global.revent[0] = "university-degree-picked-o2-refused" #this sends you back to the start of the original event asking how you would like to pay tuition, but with the option to ask your parents to pay disabled, since you already tried that and it didn't work
		$option1.text = "Okay"
		optionRemover(2)
	elif global.revent[0] == "court-trial-o2":
		if global.sumCalculator(global.crimesSeverity) <= 30:
			$heading.text = "Gone like the wind"
			$body.text = "You decided not to attend your court trial."
			$option1.text = "Sweet"
			if randi_range(1,2) == 1:
				global.revent[0] = "court-trial-o2-failed" #it secretly failed and you're about to be re-arrested
			global.commitCrime("Failing to appear", roundi(float(global.sumCalculator(global.crimesSeverity)) / 3), max(1, roundi(float(global.sumCalculator(global.crimesSeverity) / 12)))) #the more of a criminal you are, the more severe it is that you didn't show up (or tried not to)
		else:
			$heading.text = "Whattt"
			$body.text = "Your crimes are so severe that you are being held in prison until your hearing.\n\nYou cannot skip court."
			$option1.text = "Oh"
			global.revent[0] = "court-trial-o2-prison"
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
		$body.text = "Your get scolded for being unappreciative.\n- 8 relationship with your " + global.personTypes[relativeOfChoice].to_lower() + ", " + global.personFirstNames[relativeOfChoice] + ", - 12 Joy"
		$option1.text = "Okay"
		optionRemover(2)
		global.personRelationships[relativeOfChoice] -= 8 #deduct 8 relationship with gifter
		global.joy -= 12
	elif global.revent[0] == "university-degree-picked-o3":
		$heading.text = "Student loans"
		$body.text = "You took out a "
		print(global.degreePicked)
		if global.degreePicked == "education":
			print(global.degreePicked)
			$body.text += "$25,000 student loan that needs to be paid back over 20 years with an interest rate of 8%."
			global.loans.append(25000) #takes out the $25,000 loan
			global.loanInterest.append(8) #8% annual interest
			global.loanPaybackDuration.append(20) #pay it back over the course of 20 years
			print("loans: " + str(global.loans))
			print("loan interest: " + str(global.loanInterest))
			print("loan payback duration: " + str(global.loanPaybackDuration))
		global.XPQueued += 30
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
		global.commitCrime("Second degree homicide", 95, "Life")
		global.NPCKiller("kill", relativeOfChoice) #kills uncle
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
			global.XPQueued += 60
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
	prison()
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


func _on_cancel_event_pressed() -> void:
	goHome()

func _on_cancel_event_timer_timeout() -> void:
	if has_node("cancelEvent") == true: #if the button exists
		$cancelEvent.position.y = 1356 #put it in the frame
