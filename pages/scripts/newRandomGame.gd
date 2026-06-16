extends Node2D #author(s): Ethan Scott, GrayyGray
#generates a random life for the player


func cleanLife(): #resets your existing life (if any) and generates new stats
	#engine
	global.revent = []
	#personal
	global.sex = randi_range(0,1) #turns sex into a random number, either 0 or 1
	match global.sex: #assigns sex
		0: #if the number is 0, you are male
			global.sex = "M"
			print("you are male!")
		1: #if 1, you are female
			global.sex = "F"
			print("you are female!")
	global.sexuality = randi_range(1,30)
	if global.sexuality <= 15: #if you're straight
		if global.sex == "M":
			global.sexuality = "F"
		elif global.sex == "F":
			global.sexuality = "M"
	elif global.sexuality > 15 && global.sexuality <= 24: #if you're bisexual
		global.sexuality = "Bi"
	elif global.sexuality > 24: #if you're gay
		if global.sex == "M":
			global.sexuality = "M"
		elif global.sex == "F":
			global.sexuality = "F"
	global.joy = randi_range(0, 100)
	global.health = randi_range(0, 100)
	global.intellect = randi_range(0, 100)
	global.looks = randi_range(0, 100)
	global.age = 0
	global.firstName = ""
	global.lastName = ""
	global.logs = []
	global.money = 0
	global.evality = 0
	#rest-of-life-related
	global.crimes = []
	global.crimesSeverity = []
	global.intellectAtTimeOfCrime = []
	global.crimeTime = []
	global.criminalRecord = []
	global.criminalRecordSeverity = []
	global.prisonSentence = 0
	global.lawyers = []
	for i in 3: #generates a name for every law firm
			var uniqueName = ""
			var nameType = randi_range(1,4)
			var lawCompanyAppendices = ["Ruby", "Gold", "Platinum", "LA", "NY", "USA", "International", "Silver", "Emerald"]
			match nameType:
				1:
					uniqueName = global.lastNames[randi_range(0, global.lastNames.size()) - 1] + " & " + global.lastNames[randi_range(0, global.lastNames.size()) - 1]
				2:
					uniqueName = global.lastNames[randi_range(0, global.lastNames.size()) - 1] + " Criminal & Civil Lawyers"
				3:
					uniqueName = lawCompanyAppendices[randi_range(0, lawCompanyAppendices.size() - 1)] + " Law"
				4:
					uniqueName = global.lastNames[randi_range(0, global.lastNames.size()) - 1] + " & Co."
			global.lawyers.append(uniqueName)
	global.lawyerCostMultiplier = [roundi(float(randi_range(940, 1050)) / 2), roundi(float(randi_range(1400, 1520)) / 2), roundi(float(randi_range(2200, 2450)) / 2)] #fix this abomination at some point, probably
	global.lawyerTierPicked = 0
	global.multiplicativeArrestChance = 1
	global.schoolName = ""
	global.schoolLevel = -1
	global.schoolPerformanceTracker = []
	global.degrees = []
	global.degreeProficiency = []
	global.licences = []
	global.certificates = []
	global.failedCertificates = []
	global.newJobOpenings()
	global.fullTimeJob = ""
	global.fullTimeSalary = 0
	global.fullTimeEffectInitialiser()
	global.partTimeJob = ""
	global.partTimeRate = 0
	global.partTimeHours = 0
	global.workExperience = []
	global.loans = []
	global.loanInitialValue = []
	global.loanPaybackDuration = []
	global.loanInterest = []
	global.prisonSentence = 0
	#NPCs
	global.personFirstNames = []
	global.personLastNames = []
	global.personTypes = []
	global.personAges = []
	global.personSexes = []
	global.personRelationships = []
	global.personUIDsUsed = 0
	global.personUIDs = []
	global.personStats = []
	global.personCategories = []
	#dead NPCs
	global.deadPersonFirstNames = []
	global.deadPersonLastNames = []
	global.deadPersonTypes = []
	global.deadPersonAges = []
	global.deadPersonRelationships = []
	global.deadPersonSexes = []
	global.deadPersonCategories = []
	#keeping track
	global.joyOverTime.append(global.joy)
	global.healthOverTime.append(global.health)
	global.intellectOverTime.append(global.intellect)
	global.looksOverTime.append(global.looks)
	global.causeOfDeath = ""
	global.XPQueued = 0
	global.history = []
	#testing variables
	global.RAUE = true
	#prints stuff
	print("Joy: " + str(global.joy))
	print("Health: " + str(global.health))
	print("Intellect: " + str(global.intellect))
	print("Looks: " + str(global.looks))

func namePicker(): #generates a full name for the player
	print(str(global.mFirstNames.size()) + " masculine first names.")
	print(str(global.fFirstNames.size()) + " feminine first names.")
	print(str(global.uFirstNames.size()) + " unisex first names.")
	print(str(global.lastNames.size()) + " total last names.")
	print(str(global.rareFirstNames.size()) + " total rare names.") #only rare first names because rare names come in pairs. refer to the rare names array in for more information.
	print(str((global.mFirstNames.size() * global.lastNames.size()) + (global.fFirstNames.size() * global.lastNames.size()) + (global.uFirstNames.size() * global.lastNames.size()) + global.rareFirstNames.size()) + " total possible unique name combinations.")
	if randi_range(1,3000) == 1: #if you're given a rare name (1 in 3,000 chance). A further 1 in (number of rare names) chance to get a specific rare name, meaning:
		print("picking a rare name. That means there is only a 1 in " + str(3000 * global.rareFirstNames.size()) + " chance of getting the name you're about to be assigned. Impressive!")
		var rareName = randi_range(0, global.rareFirstNames.size() - 1) #since rare names come in pairs, 
		global.firstName = global.rareFirstNames[rareName] #assigns rare first name
		global.lastName = global.rareLastNames[rareName] #assigns rare last name
	else: #if you aren't given a rare name
		if randi_range(1,20) == 1: #if you're given a unisex name (1 in 20 chance)
			print("picking a unisex name (1 in 20 chance)")
			global.firstName = global.uFirstNames[randi_range(0, global.uFirstNames.size() - 1)] #assigns a random unisex first name
		else: #if you aren't given a unisex name
			match global.sex: #gives a different name depending on sex
				"M":
					global.firstName = global.mFirstNames[randi_range(0, global.mFirstNames.size() - 1)] #assigns a male name
				"F":
					global.firstName = global.fFirstNames[randi_range(0, global.fFirstNames.size() - 1)] #assigns a female name
		global.lastName = global.lastNames[randi_range(0, global.lastNames.size() - 1)] #assigns a random last name. Function does not change depending on sex.
	print("your name is " + global.firstName + " " + global.lastName)
	global.currentLife = global.getSaveLifeFileName() #sets the currentLife variable to a unique file name


func epicStatChanges(): #changes your stats, epicly, based on factors outside of your control
	if global.lastName == "Smart" || global.firstName == "Nerd": #epic stat changes
		global.intellect = 3
	elif global.lastName == "Joy":
		global.joy = 3


func familyGenerator(): #HELP I DON'T WANT TO MAKE THIS SCRIPT FOR A THIRD TIME WHY WHY WHYYYY
	#types (happens first)
	var howManyGrandparents = 0 #how many grandparents do you have, if any? number is generated later. max is 2x number of parents
	var howManyParents = 0 #how many parents do you have?
	if randi_range(1, 8) == 1: #if you have a single parent
		howManyParents = 1 #you have one parent
		if randi_range(1, 2) == 1: #if you have a single mother
			global.personTypes.append("Mother") #appends mother
		else: #if you have a single father
			global.personTypes.append("Father") #appends father
		global.personCategories.append("family")
		global.personStats.append([randi_range(0, 100)]) #gives them random stats (see global.gd)
		global.personUIDs.append(global.personUIDsUsed)
		global.personUIDsUsed += 1
		howManyGrandparents = randi_range(0, 2) #how many grandparents do you have
	else: #if you have TWO parents
		howManyParents = 2 #you have two parents
		if randi_range(1, 14) == 1: #if you have two parents of the same sex
			if randi_range(1, 2) == 1: #if two mothers
				global.personTypes.append("Mother") #appends mother
				global.personTypes.append("Mother") #appends mother
			else: #if two fathers
				global.personTypes.append("Father") #appends father
				global.personTypes.append("Father") #appends father
		else: #if you have two parents of DIFFERENT sex
			global.personTypes.append("Mother") #appends mother
			global.personTypes.append("Father") #appends father
		global.personCategories.append("family")
		global.personCategories.append("family")
		global.personStats.append([randi_range(0, 100)])
		global.personStats.append([randi_range(0, 100)])
		global.personUIDs.append(global.personUIDsUsed)
		global.personUIDsUsed += 1
		global.personUIDs.append(global.personUIDsUsed)
		global.personUIDsUsed += 1
		howManyGrandparents = randi_range(0, 4) #how many grandparents do you have
	if randi_range(1, 2) == 1: #if you're getting siblings
		var howManySiblings = randi_range(1, 4) #how many siblings will be generated
		while howManySiblings > 0: #while there are still siblings left to be generated
			if randi_range(1, 2) == 1: #if sibling is a female
				global.personTypes.append("Sister") #appends sister
			else: #if sibling is a male
				global.personTypes.append("Brother") #appends brother
			global.personCategories.append("family")
			global.personStats.append([randi_range(0, 100)])
			global.personUIDs.append(global.personUIDsUsed)
			global.personUIDsUsed += 1
			howManySiblings -= 1 #we just generated a sibling, remember? god
	while howManyGrandparents > 0: #while there are still grandparents left to generate
		if howManyGrandparents >= 2: #must be greater than or equal to 2 considering we are appending two grandparents
			if randi_range(1, 60) == 1: #if you have two grandparents of the same sex; much less likely because they are old
					if randi_range(1, 2) == 1: #if you have two grandmothers
						global.personTypes.append("Grandmother") #appends grandmother
						global.personTypes.append("Grandmother") #appends grandmother
					else: #if you have two grandfathers
						global.personTypes.append("Grandfather") #appends grandfather
						global.personTypes.append("Grandfather") #appends grandfather
			else: #if you have two grandparents of DIFFERENT sex
				global.personTypes.append("Grandmother") #appends grandmother
				global.personTypes.append("Grandfather") #appends grandfather
			global.personCategories.append("family")
			global.personCategories.append("family")
			global.personStats.append([randi_range(0, 100)])
			global.personStats.append([randi_range(0, 100)])
			global.personUIDs.append(global.personUIDsUsed)
			global.personUIDsUsed += 1
			global.personUIDs.append(global.personUIDsUsed)
			global.personUIDsUsed += 1
			howManyGrandparents -= 2 #-2 because we just appended two grandparents at once
		else: #if you only have one grandparent left to generate (can't be 0 because to be here in the first place you must have over 0)
			if randi_range(1, 2) == 1: #if you have one grandmother
				global.personTypes.append("Grandmother") #appends grandmother
			else: #if you have one grandfather
				global.personTypes.append("Grandfather") #appends grandfather
			global.personCategories.append("family")
			global.personStats.append([randi_range(0, 100)])
			global.personUIDs.append(global.personUIDsUsed)
			global.personUIDsUsed += 1
			howManyGrandparents -= 1 #1 less grandparent you need to generate
	if global.personTypes.has("Grandmother") || global.personTypes.has("Grandfather"): #you CANNOT have an aunt or uncle without grandparents for age generation reasons.
		if randi_range(1, 3) == 1: #if you have aunts/uncles
			var howManyUncaunts = randi_range(1, 4) #you may have any number of aunts/uncles between 1 and 4
			while howManyUncaunts > 0: #while there are still more aunts/uncles to generate
				if randi_range(1, 2) == 1: #if you're getting an aunt
					global.personTypes.append("Aunt") #appens aunt
				else: #if you're getting an uncle
					global.personTypes.append("Uncle") #appends uncle
				global.personCategories.append("family")
				global.personStats.append([randi_range(0, 100)])
				global.personUIDs.append(global.personUIDsUsed)
				global.personUIDsUsed += 1
				howManyUncaunts -= 1 #1 less aunt/uncle you need to generate
			if randi_range(1, 3) == 1: #if you're getting cousins - requires aunts/uncles
				var howManyCousins = randi_range(1, 5) #how many cousins you will get, from 1 to 5
				while howManyCousins > 0: #while there are still cousins left to generate
					global.personTypes.append("Cousin") #don't need to do seperate appendings by sex since cousin is a gender neutral term; sexes will be assigned later
					global.personCategories.append("family")
					global.personStats.append([randi_range(0, 100)])
					global.personUIDs.append(global.personUIDsUsed)
					global.personUIDsUsed += 1
					howManyCousins -= 1 #1 less cousin left to generate
	#sexer
	for i in global.personTypes.size(): #sets a variable, i, to run through every item in the personTypes array. Runs once for every item in it. Index of the family member corresponds with the index of their sex.
		if global.personTypes[i] == "Mother" || global.personTypes[i] == "Sister" || global.personTypes[i] == "Grandmother" || global.personTypes[i] == "Aunt": #if family member at index i is female
			global.personSexes.append("F") #appends female
		elif global.personTypes[i] == "Father" || global.personTypes[i] == "Brother" || global.personTypes[i] == "Grandfather" || global.personTypes[i] == "Uncle": #if family member at index i is male
			global.personSexes.append("M") #appends male
		else: #if family member at index i is your cousin (the only remaining possible type of family member)
			if randi_range(1, 2) == 1: #if cousin is female
				global.personSexes.append("F") #appends female
			else: #if cousin is male
				global.personSexes.append("M") #appends male
	#namer
	var parentsAreMarried = false #parents aren't married by default, but this might change:
	if howManyParents == 2: #if you have two parents
		if randi_range(1, 2) == 1: #if parents ARE married (1 in 2 chance)
			parentsAreMarried = true #then parents being married is TRUE
	for i in global.personTypes.size(): #sets a variable, i, to run through every item in the personTypes array. Runs once for every item in it. Index of the family member corresponds with the index of their name.
		#last names - Last names are assigned before first names so they can be overridden by rare names, which are all full names.
		if global.personTypes[i] == "Mother" || global.personTypes[i] == "Father": #if the family member being analysed now is a parent
			if howManyParents == 1: #if you only have one parent
				global.personLastNames.append(global.lastName) #they get your surname automatically
			elif parentsAreMarried == true: #if parents are married. If this is true, it also means that you have two parents because of how the true value gets assigned. If true, you and both of them will share the same family surname. If they are not, you and ONE of them will share one. If the family member you would have originally gotten your surname from later gets a rare name and therefore a special rare surname, I guess they made it up because now you've gotten yours from nowhere.
				global.personLastNames.append(global.lastName) #gives them the family surname
			else: #if you have two parents BUT they're aren't married
				var parentsBeforeThis = false #are there any parents in the personTypes array before this one? The first parent in the array will get your surname. False by default so it only gets changed if there are other parents before.
				var x = i-1 #used to keep track of which family member we're checking. Starts off by checking the family member before this one.
				while x >= 0: #while there are still family members earlier in the array
					if global.personTypes[x] == "Mother" || global.personTypes[x] == "Father": #if the family member at the index x is a parent, that means there is a parent before the one at i
						parentsBeforeThis = true #the parent at index i is not the first parent
					x -= 1 #advance
				if parentsBeforeThis == false: #if, after we checked, we found there aren't any parents in the array before this
					global.personLastNames.append(global.lastName) #parent gets your last name
				if parentsBeforeThis == true: #if there are parents before this one, they already have your last name instead
					global.personLastNames.append(global.lastNames[randi_range(0, global.lastNames.size() - 1)]) #gives the parent at index i a completely random last name
		else: #if family member at index i is NOT your parent
			global.personLastNames.append(global.lastNames[randi_range(0, global.lastNames.size() - 1)]) #gives them a random last name
		#first names and rare names
		if randi_range(1, 3000) == 1: #if family member is getting a rare full name
			var rareNameIndex = randi_range(0, global.rareFirstNames.size() - 1) #first name and last name have the same index. picks one random index to use.
			global.personFirstNames.append(global.rareFirstNames[rareNameIndex]) #appends the first name of the index
			global.personLastNames.pop_back() #removes (pops) the last element of the familyglobal.lastNames array. This is because this family member was already given a last name and we are about to override that with a new one.
			global.personLastNames.append(global.rareLastNames[rareNameIndex]) #appends the last name of the index
		else: #if family member is NOT getting a rare full name
			if randi_range(1, 20) == 1: #if family member is getting a unisex first name
				global.personFirstNames.append(global.uFirstNames[randi_range(0, global.uFirstNames.size() - 1)]) #appends a random unisex first name
			else: #if family member is NOT getting a unisex first name
				if global.personSexes[i] == "F": #if family member at index i is female
					global.personFirstNames.append(global.fFirstNames[randi_range(0, global.fFirstNames.size() - 1)]) #appends to personFirstNames a random female first name
				else: #if family member at index i is male
					global.personFirstNames.append(global.mFirstNames[randi_range(0, global.mFirstNames.size() - 1)]) #appends to personFirstNames a random male first name
	#relationshipper
	for i in global.personTypes.size(): #runs through and checks every family member, assigning them a relationship to you
		if global.personTypes[i] == "Mother" || global.personTypes[i] == "Father": #if family member at i is your parent
			global.personRelationships.append(randi_range(30, 100))
		elif global.personTypes[i] == "Grandmother" || global.personTypes[i] == "Grandfather": #if family member is your grandparent
			global.personRelationships.append(randi_range(30, 100))
		elif global.personTypes[i] == "Aunt" || global.personTypes[i] == "Uncle": #if family member is your aunt/uncle
			global.personRelationships.append(randi_range(20, 70))
		elif global.personTypes[i] == "Brother" || global.personTypes[i] == "Sister": #if family member is your sibling
			global.personRelationships.append(randi_range(40, 80))
		elif global.personTypes[i] == "Cousin": #if family member is your cousin
			global.personRelationships.append(randi_range(0, 30))
	#ager
	var ageOfParent
	var ageOfGrandparent
	var ageOfUncaunt
	for i in global.personTypes.size(): #runs through every family member
		if global.personTypes[i] == "Mother": #if family member at index i is your mother
			global.personAges.append(randi_range(18, 45)) #gives her a random age between 18 and 45
		elif global.personTypes[i] == "Father": #if family member at index i is your father
			global.personAges.append(randi_range(18, 45)) #men generally can father at older than around 45, unlike most women, but just for now, fathers will have the same
		#this has to happen now so the other multple family members' ages who rely on knowing the parents' ages can be generated (this does not have to happen for ageOfGrandparent and ageOfUncaunt:
		ageOfParent = global.personTypes.find("Mother") #finds index of mother. This variable is used to keep track of the age of your parents without having to re-find it every time. .find() finds the first mother in the personTypes array.
		#in case you have no mother:
		if ageOfParent == -1: #if you have NO mother; .find() returns -1 by default if it can't find anything
			ageOfParent = global.personTypes.find("Father") #finds the first FATHER in the personTypes array. If you have no mother, you MUST have a father.
		ageOfParent = global.personAges[ageOfParent] #finds the age of the parent at the index of ageOfParent
		if global.personTypes[i] == "Grandmother" || global.personTypes[i] == "Grandfather": #if family member is a grandparent
			global.personAges.append(randi_range(ageOfParent + 18, ageOfParent + 45)) #gives the grandparent an age between 18 and 45 years older than the first parent in the personTypes array
		elif global.personTypes[i] == "Brother" || global.personTypes[i] == "Sister": #if family member is a sibling
			global.personAges.append(randi_range(0, ageOfParent - 18)) #gives sibling an age between 18 and 45 years younger than the first parent in the array. Your parent would have had them between the ages of 18 and 45, so if they were 18, they would be 18 years younger than them, and if they were 45, they would be 45 years younger.
		elif global.personTypes[i] == "Aunt" || global.personTypes[i] == "Uncle": #if family member is a pibling (sidenote: pibling, or "parent's sibling" is a dumb gender-neutral term for aunt/uncle. We need a better one. I still stand by Uncaunt, a portmanteau of Uncle and Aunt coined by me. I am not biased, but that is the best one)
			ageOfGrandparent = global.personTypes.find("Grandmother") #finds index of grandmother
			if ageOfGrandparent == -1: #if you have NO grandmother
				ageOfGrandparent = global.personTypes.find("Grandfather") #if you have neither a grandmother nor a grandfather, this variable won't be used anyway. Don't lose any sleep over it.
			ageOfGrandparent = global.personAges[ageOfGrandparent] #sets ageOfGrandparent to the actual age of the grandparent at index ageOfGrandparent (set just before) (it's confusing)
			global.personAges.append(randi_range(ageOfParent, ageOfGrandparent - 18)) #gives uncaunt an age. They will be between the age of YOUR parent and 18 years younger than your grandparent (THEIR parent).
		elif global.personTypes[i] == "Cousin": #if family member is a... cousin. Look, I don't know man, this is super self-explanatory. This will only ever run if you have cousins, which will only ever happen if you have at least one aunt/uncle (see the family typer section).
			ageOfUncaunt = global.personTypes.find("Aunt") #finds index of an aunt
			if ageOfUncaunt == -1: #if you have NO aunt
				ageOfUncaunt = global.personTypes.find("Uncle") #finds the index of an uncle. Again, if you have neither an aunt nor an uncle, this variable (ageOfUncaunt) will not be used in the first place. Do not bother worrying about it.
			ageOfUncaunt = global.personAges[ageOfUncaunt] #gets the age of the Uncaunt at the index that was just acquired
			global.personAges.append(randi_range(0, ageOfUncaunt - 18)) #gives cousin an age based on the Uncaunt's age. They will be between 18 and 45 years younger than your Uncaunt (their parent).
	if randi_range(1,30000) == 1: #easter egg
		var whoIsBeyonce = randi_range(0, global.personFirstNames.size() - 1) #picks a random family member
		global.personFirstNames[whoIsBeyonce] = "Beyoncé" #beyoncéficates them
		global.personLastNames[whoIsBeyonce] = ""
	print(global.personFirstNames)
	print(global.personLastNames)
	print(global.personSexes)
	print(global.personAges)
	print(global.personTypes)
	print(global.personRelationships)
	print(global.personStats)
	print("in total, you have " + str(global.personTypes.size()) + " family members")


func legacySaveImport(path):
	var file = FileAccess.open(path, FileAccess.READ) #opens the file to read
	var data = JSON.parse_string(file.get_as_text()) #saves a parsed version of a text version of the save file
	#parses the data into variables
	print(path.get_file())
	if path.get_file() == "bob.bls": #special exceptions that I will not elaborate on
		global.firstName = "Bob"
		global.lastName = "Legacy"
	else:
		global.firstName = "Legacy"
		global.lastName = "Man" #names just weren't implemented in the original, I guess, because I can't find it in the code at all
		global.age = int(data["Age"])
		global.money = int(data["Money"])
		global.joy = int(data["Joy"])
		global.intellect = int(data["Intellect"])
		global.health = int(data["Health"])
		global.looks = int(data["Looks"])
		global.evality = int(data["Evality"])
		global.degrees = Array(JSON.parse_string(data["Degree"])) #the string needs to be turned into a packedStringArray first by seperating the elements, then that packedStringArray needs to be turned into a regular array
		global.fullTimeJob = data["Job"]
		global.fullTimePerformance = int(data["JobPerformance"])
		global.fullTimeSalary = int(data["Salary"])
		global.partTimeJob = data["PartTimeJob"]
		global.partTimePerformance = int(data["PartTimePerformance"])
		global.personSexes = Array(JSON.parse_string(data["PersonSexes"]))
		#names - in the original game, relationship names are NOT seperated by first and last name. There is ONE array called "personNames" and it contains elements in a format like this: "Jane Doe". Therefore, we need to split it at the space into two seperate names. However, this will break on names with one or more middle names, i.e. "Neil Patrick Harris". This would split into 3 or more elements where you only need two. This is why we need the middle name fixer (see below), which turns a full name with 3 or more individual names into 2.
		var firstNamesLegacy = []
		var lastNamesLegacy = []
		var allNamesLegacy = Array(JSON.parse_string(data["PersonNames"]))
		for i in allNamesLegacy.size(): #runs through every complete name from the save file ("Jane Doe")
			var thisNameSplit = Array(allNamesLegacy[i].split(" ")) #splits this FULL name into a first and last name
			#middle name fixer
			while thisNameSplit.size() >= 3: #runs indefinitely if there are 3 or more names in this ONE name until there are only two
				thisNameSplit[1] += " " + thisNameSplit[2] #appends the third name onto the second/last name. Before: ["Neil", "Patrick", "Harris"], after: ["Neil", "Patrick Harris", "Harris"] (the third name still needs to be removed)
				thisNameSplit.pop_at(2) #pops the third name ["Neil", "Patrick Harris"]
			firstNamesLegacy.append(thisNameSplit[0])
			lastNamesLegacy.append(thisNameSplit[1])
		global.personFirstNames = firstNamesLegacy #we're now done. makes permanent changes
		global.personLastNames = lastNamesLegacy
		global.personTypes = Array(JSON.parse_string(data["PersonRoles"]))
		for i in global.personTypes.size(): #generates person CATEGORIES (family or misc)
			if global.personTypes[i] == "Mother" || global.personTypes[i] == "Father" || global.personTypes[i] == "Brother" || global.personTypes[i] == "Sister" || global.personTypes[i] == "Aunt" || global.personTypes[i] == "Uncle" || global.personTypes[i] == "Cousin" || global.personTypes[i] == "Grandmother" || global.personTypes[i] == "Grandfather":
				global.personCategories.append("family")
			else:
				global.personCategories.append("misc")
		global.personAges = Array(JSON.parse_string(data["PersonAges"]))
		for i in global.personAges.size(): #turns all elements in personAges into an integer
			global.personAges[i] = int(global.personAges[i])
		global.personRelationships = Array(JSON.parse_string(data["PersonRelationships"]))
		for i in global.personRelationships.size(): #turns all elements in personRelationships into an integer
			global.personRelationships[i] = int(global.personRelationships[i])
		global.personStats = []
		global.personUIDs = []
		global.personUIDsUsed = 0
		for i in global.personTypes.size(): #runs through every person
			global.personStats.append([randi_range(0, 100)]) #gives them random stats (see global.gd)
			global.personUIDs.append(global.personUIDsUsed)
			global.personUIDsUsed += 1
		global.currentLife = global.getSaveLifeFileName() #sets the currentLife variable to a unique file name
		global.saveGame() #saves so you can continue it right away
		print(global.currentLife)
	file.close() #closes the file so it doesn't stay open and do anything weird
	global.importLegacySave = "" #resets the path so it doesn't automatically load next time


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame #waits until the frame is fully loaded. Without this, the screen sometimes flashes gray while on this scene
	$loadingText.text = global.tips[randi_range(0, global.tips.size() - 1)] #picks a random tip to display. Must be size -1 because arrays are 0-indexed, meaning that the number of items in the array will be 1 more than the index of the last item.
	cleanLife()
	namePicker()
	epicStatChanges()
	familyGenerator() #:sob:
	print("life generated. starting...")
	if global.importLegacySave != "": #if there is a legacy save file we should load before beginning this new life
		legacySaveImport(global.importLegacySave)
	get_tree().change_scene_to_file("res://pages/game_menu.tscn") #transport to main game page once loading is finished
