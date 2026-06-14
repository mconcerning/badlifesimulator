extends Node2D #author(s): Ethan Scott


var isDying = false


func basicStatChanges():
	global.age += 1 #the actual aging up
	print("age is now " + str(global.age))
	global.joy += randi_range(-6, 6) #randomly tweaks joy levels. can add anywhere from -6 (subtracts 6) to 6 (adds 6).
	global.health += randi_range(-6, 6)
	global.intellect += randi_range(-4, 4)
	global.looks += randi_range(-6, 6)
	#income tax bracketer - modelled loosely after the Australian resident tax rates 2025 - 2026
	var combinedSalary = global.fullTimeSalary + global.partTimeSalary
	var costOfLiving = 0 #cost of living expressed as a percentage. Cost of living is 0% is you have no income so as to prevent unnecessary debt.
	if combinedSalary <= 18200:
		global.incomeTax = 0 #0% income tax
		costOfLiving = 60 #wishful thinking but it's not fun to have 0 income
	elif combinedSalary > 18200 && combinedSalary <= 45000:
		global.incomeTax = 16 #16% income tax
		costOfLiving = 60
	elif combinedSalary > 45000 && combinedSalary <= 135000:
		global.incomeTax = 30
		costOfLiving = 50
	elif combinedSalary > 135000 && combinedSalary <= 190000:
		global.incomeTax = 37
		costOfLiving = 40
	elif combinedSalary > 190000:
		global.incomeTax = 45
		costOfLiving = 30
	global.money += roundi(float(combinedSalary) / 100 * (100 - global.incomeTax - costOfLiving)) #salary giver. Deducts a certain percentage for income tax.
	#print(str(global.incomeTax) + "% income tax")
	#print("you earned $" + global.commaiser(combinedSalary))
	#print("you paid $" + global.commaiser(combinedSalary - roundi(float(combinedSalary) / 100 * (100 - global.incomeTax))) + " in income tax")
	#print("you earned $" + global.commaiser(roundi(float(combinedSalary) / 100 * (100 - global.incomeTax))) + " after tax")
	#accrewing of debt
	if global.money < 0 && global.age >= 18: #if you're in debt
		var debtInterest = roundi(float(-global.money) / 100 * 14) #your interest is 14%
		global.money -= debtInterest
		print("paid $" + global.commaiser(debtInterest) + " in debt interest")
	#job effects
	global.joy += global.fullTimeEffectJoy
	global.health += global.fullTimeEffectHealth
	global.intellect += global.fullTimeEffectIntellect
	global.looks += global.fullTimeEffectLooks
	global.evality += global.fullTimeEffectEvality
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
	if global.crimes.size() >= 1: #if you have committed a crime
		if global.multiplicativeArrestChance <= 1.75:
			global.multiplicativeArrestChance += 0.25
		elif global.isBetween(global.multiplicativeArrestChance, 1.75, 2, false) == true: #if your chance is between 1.75 and 2
			global.multiplicativeArrestChance = 2
		if global.crimes.find("Failing to appear") != -1: #if you have skipped court
			global.multiplicativeArrestChance += 1
	global.statClamper() #clamps stats if they're below 0 or above 100
	global.history = [] #clears activity history
	global.newJobOpenings()


func school():
	if global.schoolLevel != -1 && global.schoolLevel != 0: #if you have not not entered school yet and have not graduated yet (i.e. you are in school)
		global.workExperience.append("school-" + str(global.schoolLevel)) #adds schooling as work experience - this is used and removed only when you graduated
		if global.schoolPerformance < global.intellect: #if you're not doing as well as your functional maximum
			global.schoolPerformance = min(global.intellect, global.schoolPerformance + float(global.intellect) / 10) #you work towards it
		elif global.schoolPerformance > global.intellect: #if you're less intelligent than your school performance
			if randi_range(1,3) == 1: #if you lose performance (1 in 3 chance)
				global.schoolPerformance = max(global.intellect, global.schoolPerformance - roundi(float(global.intellect) / 10)) #lose some performance
			else: #if you gain intellect instead (2 in 3 chance)
				global.intellect += roundi(float(global.schoolPerformance) / 10)
		global.schoolPerformance += randi_range(-4, 4)
		global.intellect += round(float(global.schoolPerformance) / 12) + randi_range(-3, 3) #if you're doing well in school, you're getting smarter
		global.XPQueued += 3
		global.schoolPerformanceTracker.append(global.schoolPerformance)
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
		global.schoolPerformanceTracker = []
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
		global.degreeProficiency.append(global.averageFinder(global.schoolPerformanceTracker))
		global.schoolPerformanceTracker = []
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
		global.degreeProficiency.append(global.averageFinder(global.schoolPerformanceTracker))
		global.schoolPerformanceTracker = []
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
		global.degreeProficiency.append(global.averageFinder(global.schoolPerformanceTracker))
		global.schoolPerformanceTracker = []
		#rids work experience of school-3
		var workExpDupe = []
		for i in global.workExperience.size():
			if global.workExperience[i] != "school-3":
				workExpDupe.append(global.workExperience[i])
		global.workExperience = workExpDupe
		print("graduated university")
		global.XPQueued += 50


func job():
	if global.fullTimeJob != "": #if you have a full-time job
		if global.fullTimePerformance <= 35 && randi_range(1, roundi(float(global.fullTimePerformance) / 10)) == 1: #if you're performing too poorly and end up getting fired
			global.revent.append("full-time-fired-performance")
		else: #if you haven't been fired
			global.workExperience.append(global.fullTimeJob) #you get work experience for it
			global.XPQueued += 25
			global.fullTimePerformance += randi_range(-6, 6)
	if global.partTimeJob != "": #if you have a part-time job
		global.workExperience.append(global.partTimeJob) #you get work experience for it
		global.XPQueued += 15
		global.partTimePerformance += randi_range(-6, 6)


func imprisonment(): #handles your chances of being arrested
	if global.sumCalculator(global.crimesSeverity) >= 10: #if you've committed serious enough crimes to warrant being arrested for them
		if (randi_range(max(1, global.sumCalculator(global.crimesSeverity) - 20), global.sumCalculator(global.crimesSeverity) * (global.multiplicativeArrestChance / 2)) * global.multiplicativeArrestChance) >= global.averageFinder(global.intellectAtTimeOfCrime) && (randi_range(10,120) / global.multiplicativeArrestChance) <= global.sumCalculator(global.crimesSeverity):
				global.revent.append("arrested")


func loanHandler(): #i hate maths so much oh my god
	if global.loans.size() > 0: #if you have loans taken out
		print("loans: " + str(global.loans))
		var i = global.loans.size() - 1 #iterates backwards because we're removing elements
		while i >= 0: #runs through every loan you need to pay back and pays back the amount you owe
			global.loans[i] = roundi(float(global.loans[i]) * (1 + float(global.loanInterest[i]) / 100)) #adds interest
			print("paying back " + str(float(global.loans[i]) / global.loanInterest[i] / global.loans[i] * 100) + "% of your $" + str(global.loans[i]) + " loan (due in " + str(global.loanPaybackDuration[i] - 1) + " year(s))")
			var amountOwed = roundi(float(global.loans[i]) / global.loanPaybackDuration[i]) #calculates the amount of money you owe
			global.money -= amountOwed #deducts the amount you owe from your balance
			global.loans[i] -= amountOwed  #you just paid back some of the loan, so the amount you owe is now smaller (although the interest makes it a little bit higher than it would be without it)
			global.loanPaybackDuration[i] -= 1 #one year has now passed, you have one less year to pay back the loan
			print("paid some back. loan now $" + str(global.loans[i]))
			if global.loans[i] <= 100: #if you owe less than $100 (I guess this could technically happen before a loan expires due to weird rounding, but it would also happen when you've fully paid a loan back (the amount you need to pay back would be 0))
				global.money -= global.loans[i] #just pay back any more money you owe (or get a refund if this number is negative (probably technically possible due to rounding but I'm not doing that maths because it doesn't really matter if it is))
				global.loans.pop_at(i) #*chanting* NO MORE LOAN!
				global.loanInitialValue.pop_at(i) #NO MORE LOAN!
				global.loanPaybackDuration.pop_at(i) #NO MORE LOAN!
				global.loanInterest.pop_at(i) #NO MORE LOAN!
				print("no more loan at index " + str(i))
			i -= 1


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
	if global.age >= 69: #if you're old enough to randomly die (not super realistic, but as it turns out, it is NOT fun dying for no reason at age 2)
		var chance = randi_range(1, max(1, 70 - global.age + roundi(float(global.health) / 2))) # equation for age at which death is inevitable at x health (max age): a = 69 + health / 2
		# equation for the health that would no longer be able to keep you alive at x age: h = (a - 69) * 2
		#print(70 - global.age + roundi(float(global.health) / 2))
		#print(chance)
		print("1 in " + str(chance) + " chance of death")
		if chance == 1:
			global.causeOfDeath = "You died of complications associated with advanced age"
			isDying = true
			get_tree().change_scene_to_file("res://pages/death.tscn") #kills you


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame #waits until the frame is fully loaded. Without this, the screen flashes gray while on this scene
	basicStatChanges()
	school()
	job()
	loanHandler()
	ageUpEventHandler()
	rareAgeUpEvents()
	randomDeathChance()
	imprisonment()
	if isDying == true: #if you're dying
		return #don't do anything below
	#runs events if they're queued
	if global.revent.size() > 0: #if there are random events slated to appear
		get_tree().change_scene_to_file("res://pages/event.tscn") #goes to the event page
	else: #if there aren't random events slated to appear
		get_tree().change_scene_to_file("res://pages/game_menu.tscn") #goes back to game menu
