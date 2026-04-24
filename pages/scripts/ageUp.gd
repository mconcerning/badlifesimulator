extends Node2D #author(s): Ethan Scott


func basicStatChanges():
	global.age += 1 #the actual aging up
	print("age is now " + str(global.age))
	global.joy += randi_range(-6, 6) #randomly tweaks joy levels. can add anywhere from -6 (subtracts 6) to 6 (adds 6).
	global.health += randi_range(-6, 6)
	global.intellect += randi_range(-4, 4)
	global.looks += randi_range(-6, 6)
	#over-timers
	global.joyOverTime.append(global.joy)
	global.healthOverTime.append(global.health)
	global.intellectOverTime.append(global.intellect)
	global.looksOverTime.append(global.looks)
	for i in global.personAges.size(): #runs through every NPC and ages them up
		global.personAges[i] += 1
		var stats = global.personStats[i]
		for x in stats.size(): #runs through all their stats
			if global.personStatsDictionary[x] == "joy":
				stats[x] += randi_range(-6, 6)
	global.statClamper() #clamps stats if they're below 0 or above 100
	global.history = [] #clears activity history


func school():
	if global.schoolLevel != -1 && global.schoolLevel != 0: #if you have not not entered school yet and have not graduated yet (i.e. you are in school)
		global.workExperience.append("school-" + str(global.schoolLevel)) #adds schooling as work experience - this is used and removed only when you graduated
		if global.schoolPerformance < global.intellect: #if you're not doing as well as your functional maximum
			global.schoolPerformance = min(global.intellect, global.schoolPerformance + float(global.intellect) / 10) #you work towards it
		global.schoolPerformance += randi_range(-5, 5)
		global.intellect += round(float(global.schoolPerformance) / 12) + randi_range(-3, 3) #if you're doing well in school, you're getting smarter
		global.XPQueued += 3
	#primary school
	if (global.age == 4 && global.schoolLevel == -1 && randi_range(1,2) == 1) || (global.age == 5 && global.schoolLevel == -1): #if you're 4 years old and aren't in school yet, there's a 1 in 2 chance of you getting put in primary school early, and if you're 5 and not in school yet, you automatically get put in no matter what
		global.schoolLevel = 1 #you get put in primary school
		global.schoolName = global.lastNames[randi_range(0, global.lastNames.size() - 1)] #makes school's name a random last name. Since some rare last names are just straight up blank... I'm not including those.
		match randi_range(1,3): #gives the high school a random appendix to make a full name, i.e. "McKenzie College"
			1:
				global.schoolName += " Academy"
			2:
				global.schoolName += " College"
			3:
				global.schoolName += " Primary School"
		global.revent.append("enrolled-in-primary-school")
		global.schoolPerformance = global.intellect + randi_range(-6, 6) #you are doing as well in school as you are intelligent, with a little bit of random variation (sets your performance for the first time so it's not immediately blank)
		print("you are now attending " + global.schoolName + ", a level " + str(global.schoolLevel) + " school")
	#high school
	if global.workExperience.count("school-1") == 7: #if you've already been attending primary school for 7 years
		global.schoolLevel = 2 #moves you to high school
		global.schoolName = global.lastNames[randi_range(0, global.lastNames.size() - 1)] #gives the high school a random name
		match randi_range(1,3): #gives the high school name a random appendix
			1:
				global.schoolName += " Academy"
			2:
				global.schoolName += " College"
			3:
				global.schoolName += " High School"
		global.revent.append("enrolled-in-high-school")
		global.degrees.append("primary-school") #congratulations! you now have... a primary school degree...
		#duplicates the workExperience array but without primary school experience since we will never need it for anything ever again, then replaces global.workExperience with the smaller duplicate
		var workExpDupe = []
		for i in global.workExperience.size():
			if global.workExperience[i] != "school-1":
				workExpDupe.append(global.workExperience[i])
		global.workExperience = workExpDupe
		print("you are now attending " + global.schoolName + ", a level " + str(global.schoolLevel) + " school")
	#high school graduation
	elif global.workExperience.count("school-2") == 6: #if you've been going to high school for 6 years
		global.schoolLevel = 0 #officially graduates you; you're out of school now
		global.revent.append("graduated-high-school")
		global.degrees.append("high-school")
		#duplicates the workExperience array but without high school experience since we will never need it for anything ever again, then replaces global.workExperience with the smaller duplicate
		var workExpDupe = []
		for i in global.workExperience.size():
			if global.workExperience[i] != "school-2":
				workExpDupe.append(global.workExperience[i])
		global.workExperience = workExpDupe
		print("graduated high school")
		global.XPQueued += 20
	#university enrollment happens in an event
	#university graduation
	elif global.workExperience.count("school-3") == 4: #if you've been in university for 4 years
		global.schoolLevel = 0 #officially graduates you
		global.revent.append("graduated-university")
		global.degrees.append(global.degreePicked)
		#rids work experience of school-3
		var workExpDupe = []
		for i in global.workExperience.size():
			if global.workExperience[i] != "school-3":
				workExpDupe.append(global.workExperience[i])
		global.workExperience = workExpDupe
		print("graduated university")
		global.XPQueued += 50


func imprisonment(): #handles your chances of being arrested
	print("average intellect at times of criminal activity: " + str(global.averageFinder(global.intellectAtTimeOfCrime)))
	if global.crimeSeverityCalculator() >= 10: #if you've committed serious enough crimes to warrant being arrested for them
		if randi_range(1,2) == 1:
			if randi_range(20,100) >= global.averageFinder(global.intellectAtTimeOfCrime):
				print("uh oh spaghetti-o... go directly to jail")
	push_warning("add stuff for getting arrested on age up")


func loanHandler():
	if global.loans.size() > 0: #if you have loans taken out
		for i in global.loans.size(): #runs through every loan you need to pay back and pays back the amount you owe
			print("paying back " + str(global.loan[i] / global.loanPaybackDuration[i] / global.loan[i] * 100) + "% of your $" + str(global.loan[i]) + " loan (due in " + str(global.loanPaybackDuration[i] - 1) + " year(s))")
			var amountOwed = global.loans[i] * (global.loanInterest[i] / 100 * (1 + global.loanInterest[i] / 100) ** global.loanPaybackDuration[i]) / ((1 + global.loanInterest[i] / 100) ** global.loanPaybackDuration[i] - 1) #calculates the amount of money you owe (I hate maths so much oh my god)
			global.money -= amountOwed #deducts the amount you owe from your balance
			global.loan[i] -= amountOwed - (global.loan[i] * global.loanInterest[i] / 100) #you just paid back some of the loan, so the amount you owe is now smaller (although the interest makes it a little bit higher than it would be without it)
			global.loanPaybackDuration[i] -= 1 #one year has now passed, you have one less year to pay back the loan
			if global.loans[i] <= 100: #if you owe less than $100 (I guess this could technically happen before a loan expires due to weird rounding, but it would also happen when you've fully paid a loan back (the amount you need to pay back would be 0))
				global.money -= global.loans[i] #just pay back any more money you owe (or get a refund if this number is negative (probably technically possible due to rounding but I'm not doing that maths because it doesn't really matter if it is))
				global.loans.pop_at(i) #*chanting* NO MORE LOAN!
				global.loanPaybackDuration.pop_at(i) #NO MORE LOAN!
				global.loanInterest.pop_at(i) #NO MORE LOAN!
				print("no more loan")


func ageUpEventHandler():
	if randi_range(1, 2) == 1 && global.RAUE == true: #if you're getting a random event (1 in 2 chance) and random events are enabled
		global.XPQueued += 15 #gives you XP for experiencing something
		if global.age >= 2: #you must be 2 or over to get random age up events
			print("choosing random age up event...")
			if global.age <= 4: #if age is 4 or below
				global.revent.append("toddler-" + str(randi_range(0, 0))) #second number in the randi_range is the last ID for the event that exists
			elif global.age >= 5 && global.age <= 12: #if age is between 5 and 12
				global.revent.append("child-" + str(randi_range(0, 0)))
			elif global.age >= 13 && global.age <= 19: #if age is between 13 and 19
				global.revent.append("teenager-" + str(randi_range(0, 0)))
			elif global.age >= 20 && global.age <= 65: #if age is between 20 and 65
				global.revent.append("adult-" + str(randi_range(0, 0)))
			elif global.age >= 66: #if age is over 66
				global.revent.append("elder-" + str(randi_range(0, 0)))
			print("appended event " + str(global.revent[global.revent.size() - 1])) #prints the last event ID (the one that was just appended) in the revent array
	if randi_range(1, 20) == 1 && global.RAUE == true: #if you're randomly getting a new friend :) and RAUE is enabled
		global.XPQueued += 15 #gives you XP for experiencing something
		if global.age <= 4: #if age is 4 or below
			global.revent.append("toddler-friend")
		elif global.age >= 5 && global.age <= 12: #if age is between 5 and 12
			global.revent.append("child-friend")
		elif global.age >= 13 && global.age <= 19: #if age is between 13 and 19
			global.revent.append("teenager-friend")
		elif global.age >= 20 && global.age <= 65: #if age is between 20 and 65
			global.revent.append("adult-friend")
		elif global.age >= 66: #if age is over 66
			global.revent.append("elder-friend")
		print("appended event " + str(global.revent[global.revent.size() - 1])) #prints the last event ID (the one that was just appended) in the revent array


func rareAgeUpEvents():
	pass


func randomDeathChance():
	if global.age >= 50: #if you're old enough to randomly die (not super realistic, but as it turns out, it is NOT fun dying for no reason at age 2)
		print("1 in " + str(max(1, 4 + global.health * 3 - global.age * 2)) + " chance of death")
		if randi_range(1, max(1, 4 + global.health * 3 - global.age * 2)) == 1:
			global.causeOfDeath = "You died of complications associated with advanced age"
			get_tree().change_scene_to_file("res://pages/death.tscn") #kills you


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame #waits until the frame is fully loaded. Without this, the screen flashes gray while on this scene
	basicStatChanges()
	school()
	loanHandler()
	ageUpEventHandler()
	rareAgeUpEvents()
	randomDeathChance()
	imprisonment()
	#runs events if they're queued
	if get_tree() == null: #if the scene tree DOESN'T exist (true if you're dying)
		return #don't do the below
	if global.revent.size() > 0: #if there are random events slated to appear
		get_tree().change_scene_to_file("res://pages/event.tscn") #goes to the event page
	else: #if there aren't random events slated to appear
		get_tree().change_scene_to_file("res://pages/game_menu.tscn") #goes back to game menu
