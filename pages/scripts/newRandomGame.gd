extends Node2D #author(s): Ethan Scott, GrayyGray
#generates a random life for the player


func loadList(path, splitter): #loads list of anything from a seperate file :) used for names. thanks to GrayyGray for using this method originally in a fork
	return FileAccess.get_file_as_string(path).split(splitter) #items in the list are split up by commas followed by spaces
#lists end in a comma followed by a space so any useless data after it (i.e. a new line) is included as the last element, which is popped (removed) when this script is loaded. must be strictly typed as arrays because otherwise godot automatically makes the name arrays and other string arrays into "packed string arrays", which don't let you remove elements as far as I know, but are more memory-efficient than regular arrays. Trust me, I would use those if I could.


var tips : Array = loadList("res://data/tips.txt", " | ") #tips to be displayed on the screen during loading :) - items in THIS list are seperated by " | "


#name variables
var mFirstNames : Array = loadList("res://data/names/mFirstNames.txt", ", ") #loads list of masculine first names
var fFirstNames : Array = loadList("res://data/names/fFirstNames.txt", ", ") #feminine first names
var uFirstNames : Array = loadList("res://data/names/uFirstNames.txt", ", ") #unisex first names
var lastNames : Array = loadList("res://data/names/lastNames.txt", ", ") #dude just look at the variable name
var rareFirstNames : Array = loadList("res://data/names/rareFirstNames.txt", ", ") #only generated in pairs of first name and last name. Regular names roll once for a first name and again to pick a last name, whereas rare names only roll once and pick the corresponding first and last name. So picking "Rob" as a rare first name cannot result in the name "Rob Salad", it will always result in "Rob Ery" as they are both at the same index. This is to make seperating first and last names easier, but also preserve the rare name as originally intended.
var rareLastNames : Array = loadList("res://data/names/rareLastNames.txt", ", ") #Marl and ™ have only a first name. This will result in some weird behaviour, such as the player being called "Mr./Mrs.[blank]", but that is a sarcrifice I am willing to make.


func arrayCleaner(): #removes the last element of all IMPORTED arrays (from a txt file in res://data/), which SHOULD be occupied by dead space and no actual data
	tips.pop_back()
	mFirstNames.pop_back()
	fFirstNames.pop_back()
	uFirstNames.pop_back()
	lastNames.pop_back()
	rareFirstNames.pop_back()
	rareLastNames.pop_back()


func cleanLife(): #resets your existing life (if any) and generates new stats
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
	global.logs = ""
	global.money = 0
	global.evality = 0
	global.crimes = []
	global.crimesSeverity = []
	global.familyFirstNames = []
	global.familyLastNames = []
	global.familyTypes = []
	global.familyAges = []
	global.familyRelationships = []
	global.familySexes = []
	global.miscFirstNames = []
	global.miscLastNames = []
	global.miscTypes = []
	global.miscAges = []
	global.miscRelationships = []
	global.miscSexes = []
	print("Joy: " + str(global.joy))
	print("Health: " + str(global.health))
	print("Intellect: " + str(global.intellect))
	print("Looks: " + str(global.looks))
	global.joyOverTime.append(global.joy)
	global.healthOverTime.append(global.health)
	global.intellectOverTime.append(global.intellect)
	global.looksOverTime.append(global.looks)
	global.causeOfDeath = ""
	global.XPQueued = 0

func namePicker(): #generates a full name for the player
	print(str(mFirstNames.size()) + " masculine first names.")
	print(str(fFirstNames.size()) + " feminine first names.")
	print(str(uFirstNames.size()) + " unisex first names.")
	print(str(lastNames.size()) + " total last names.")
	print(str(rareFirstNames.size()) + " total rare names.") #only rare first names because rare names come in pairs. refer to the rare names array in for more information.
	print(str((mFirstNames.size() * lastNames.size()) + (fFirstNames.size() * lastNames.size()) + (uFirstNames.size() * lastNames.size()) + rareFirstNames.size()) + " total possible unique name combinations.")
	if randi_range(1,3000) == 1: #if you're given a rare name (1 in 3,000 chance). A further 1 in (number of rare names) chance to get a specific rare name, meaning:
		print("picking a rare name. That means there is only a 1 in " + str(3000 * rareFirstNames.size()) + " chance of getting the name you're about to be assigned. Impressive!")
		var rareName = randi_range(0, rareFirstNames.size() - 1) #since rare names come in pairs, 
		global.firstName = rareFirstNames[rareName] #assigns rare first name
		global.lastName = rareLastNames[rareName] #assigns rare last name
	else: #if you aren't given a rare name
		if randi_range(1,20) == 1: #if you're given a unisex name (1 in 20 chance)
			print("picking a unisex name (1 in 20 chance)")
			global.firstName = uFirstNames[randi_range(0, uFirstNames.size() - 1)] #assigns a random unisex first name
		else: #if you aren't given a unisex name
			match global.sex: #gives a different name depending on sex
				"M":
					global.firstName = mFirstNames[randi_range(0, mFirstNames.size() - 1)] #assigns a male name
				"F":
					global.firstName = fFirstNames[randi_range(0, fFirstNames.size() - 1)] #assigns a female name
		global.lastName = lastNames[randi_range(0, lastNames.size() - 1)] #assigns a random last name. Function does not change depending on sex.
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
			global.familyTypes.append("Mother") #appends mother
		else: #if you have a single father
			global.familyTypes.append("Father") #appends father
		howManyGrandparents = randi_range(0, 2) #how many grandparents do you have
	else: #if you have TWO parents
		howManyParents = 2 #you have two parents
		if randi_range(1, 14) == 1: #if you have two parents of the same sex
			if randi_range(1, 2) == 1: #if two mothers
				global.familyTypes.append("Mother") #appends mother
				global.familyTypes.append("Mother") #appends mother
			else: #if two fathers
				global.familyTypes.append("Father") #appends father
				global.familyTypes.append("Father") #appends father
		else: #if you have two parents of DIFFERENT sex
			global.familyTypes.append("Mother") #appends mother
			global.familyTypes.append("Father") #appends father
		howManyGrandparents = randi_range(0, 4) #how many grandparents do you have
	if randi_range(1, 2) == 1: #if you're getting siblings
		var howManySiblings = randi_range(1, 4) #how many siblings will be generated
		while howManySiblings > 0: #while there are still siblings left to be generated
			if randi_range(1, 2) == 1: #if sibling is a female
				global.familyTypes.append("Sister") #appends sister
			else: #if sibling is a male
				global.familyTypes.append("Brother") #appends brother
			howManySiblings -= 1 #we just generated a sibling, remember? god
	while howManyGrandparents > 0: #while there are still grandparents left to generate
		if howManyGrandparents >= 2: #must be greater than or equal to 2 considering we are appending two grandparents
			if randi_range(1, 60) == 1: #if you have two grandparents of the same sex; much less likely because they are old
					if randi_range(1, 2) == 1: #if you have two grandmothers
						global.familyTypes.append("Grandmother") #appends grandmother
						global.familyTypes.append("Grandmother") #appends grandmother
					else: #if you have two grandfathers
						global.familyTypes.append("Grandfather") #appends grandfather
						global.familyTypes.append("Grandfather") #appends grandfather
					howManyGrandparents -= 2 #-2 because we just appended two grandparents at once
			else: #if you have two grandparents of DIFFERENT sex
				global.familyTypes.append("Grandmother") #appends grandmother
				global.familyTypes.append("Grandfather") #appends grandfather
				howManyGrandparents -= 2 #-2 because we just appended two grandparents at once
		else: #if you only have one grandparent left to generate (can't be 0 because to be here in the first place you must have over 0)
			if randi_range(1, 2) == 1: #if you have one grandmother
				global.familyTypes.append("Grandmother") #appends grandmother
			else: #if you have one grandfather
				global.familyTypes.append("Grandfather") #appends grandfather
			howManyGrandparents -= 1 #1 less grandparent you need to generate
	if global.familyTypes.has("Grandmother") || global.familyTypes.has("Grandfather"): #you CANNOT have an aunt or uncle without grandparents for age generation reasons.
		if randi_range(1, 3) == 1: #if you have aunts/uncles
			var howManyUncaunts = randi_range(1, 4) #you may have any number of aunts/uncles between 1 and 4
			while howManyUncaunts > 0: #while there are still more aunts/uncles to generate
				if randi_range(1, 2) == 1: #if you're getting an aunt
					global.familyTypes.append("Aunt") #appens aunt
				else: #if you're getting an uncle
					global.familyTypes.append("Uncle") #appends uncle
				howManyUncaunts -= 1 #1 less aunt/uncle you need to generate
			if randi_range(1, 3) == 1: #if you're getting cousins - requires aunts/uncles
				var howManyCousins = randi_range(1, 5) #how many cousins you will get, from 1 to 5
				while howManyCousins > 0: #while there are still cousins left to generate
					global.familyTypes.append("Cousin") #don't need to do seperate appendings by sex since cousin is a gender neutral term; sexes will be assigned later
					howManyCousins -= 1 #1 less cousin left to generate
	#sexer
	for i in global.familyTypes.size(): #sets a variable, i, to run through every item in the familyTypes array. Runs once for every item in it. Index of the family member corresponds with the index of their sex.
		if global.familyTypes[i] == "Mother" || global.familyTypes[i] == "Sister" || global.familyTypes[i] == "Grandmother" || global.familyTypes[i] == "Aunt": #if family member at index i is female
			global.familySexes.append("F") #appends female
		elif global.familyTypes[i] == "Father" || global.familyTypes[i] == "Brother" || global.familyTypes[i] == "Grandfather" || global.familyTypes[i] == "Uncle": #if family member at index i is male
			global.familySexes.append("M") #appends male
		else: #if family member at index i is your cousin (the only remaining possible type of family member)
			if randi_range(1, 2) == 1: #if cousin is female
				global.familySexes.append("F") #appends female
			else: #if cousin is male
				global.familySexes.append("M") #appends male
	#namer
	var parentsAreMarried = false #parents aren't married by default, but this might change:
	if howManyParents == 2: #if you have two parents
		if randi_range(1, 2) == 1: #if parents ARE married (1 in 2 chance)
			parentsAreMarried = true #then parents being married is TRUE
	for i in global.familyTypes.size(): #sets a variable, i, to run through every item in the familyTypes array. Runs once for every item in it. Index of the family member corresponds with the index of their name.
		#last names - Last names are assigned before first names so they can be overridden by rare names, which are all full names.
		if global.familyTypes[i] == "Mother" || global.familyTypes[i] == "Father": #if the family member being analysed now is a parent
			if howManyParents == 1: #if you only have one parent
				global.familyLastNames.append(global.lastName) #they get your surname automatically
			elif parentsAreMarried == true: #if parents are married. If this is true, it also means that you have two parents because of how the true value gets assigned. If true, you and both of them will share the same family surname. If they are not, you and ONE of them will share one. If the family member you would have originally gotten your surname from later gets a rare name and therefore a special rare surname, I guess they made it up because now you've gotten yours from nowhere.
				global.familyLastNames.append(global.lastName) #gives them the family surname
			else: #if you have two parents BUT they're aren't married
				var parentsBeforeThis = false #are there any parents in the familyTypes array before this one? The first parent in the array will get your surname. False by default so it only gets changed if there are other parents before.
				var x = i-1 #used to keep track of which family member we're checking. Starts off by checking the 
				while x >= 0: #while there are still family members earlier in the array before this one
					if global.familyTypes[x] == "Mother" || global.familyTypes[x] == "Father": #if the family member at the index x is a parent, that means there is a parent before the one at i
						parentsBeforeThis = true #the parent at index i is not the first parent
					x -= 1 #advance
				if parentsBeforeThis == false: #if, after we checked, we found there aren't any parents in the array before this
					global.familyLastNames.append(global.lastName) #parent gets your last name
		else: #if family member at index i is NOT your parent
			global.familyLastNames.append(lastNames[randi_range(0, lastNames.size() - 1)]) #gives them a random last name
		#first names and rare names
		if randi_range(1, 3000) == 1: #if family member is getting a rare full name
			var rareNameIndex = randi_range(0, rareFirstNames.size() - 1) #first name and last name have the same index. picks one random index to use.
			global.familyFirstNames.append(rareFirstNames[rareNameIndex]) #appends the first name of the index
			global.familyLastNames.pop_back() #removes (pops) the last element of the familyLastNames array. This is because this family member was already given a last name and we are about to override that with a new one.
			global.familyLastNames.append(rareLastNames[rareNameIndex]) #appends the last name of the index
		else: #if family member is NOT getting a rare full name
			if randi_range(1, 20) == 1: #if family member is getting a unisex first name
				global.familyFirstNames.append(uFirstNames[randi_range(0, uFirstNames.size() - 1)]) #appends a random unisex first name
			else: #if family member is NOT getting a unisex first name
				if global.familySexes[i] == "F": #if family member at index i is female
					global.familyFirstNames.append(fFirstNames[randi_range(0, fFirstNames.size() - 1)]) #appends to familyFirstNames a random female first name
				else: #if family member at index i is male
					global.familyFirstNames.append(mFirstNames[randi_range(0, mFirstNames.size() - 1)]) #appends to familyFirstNames a random male first name
	#relationshipper
	for i in global.familyTypes.size(): #runs through and checks every family member, assigning them a relationship to you
		if global.familyTypes[i] == "Mother" || global.familyTypes[i] == "Father": #if family member at i is your parent
			global.familyRelationships.append(randi_range(30, 100))
		elif global.familyTypes[i] == "Grandmother" || global.familyTypes[i] == "Grandfather": #if family member is your grandparent
			global.familyRelationships.append(randi_range(30, 100))
		elif global.familyTypes[i] == "Aunt" || global.familyTypes[i] == "Uncle": #if family member is your aunt/uncle
			global.familyRelationships.append(randi_range(20, 70))
		elif global.familyTypes[i] == "Brother" || global.familyTypes[i] == "Sister": #if family member is your sibling
			global.familyRelationships.append(randi_range(40, 80))
		elif global.familyTypes[i] == "Cousin": #if family member is your cousin
			global.familyRelationships.append(randi_range(0, 30))
	#ager
	var ageOfParent
	var ageOfGrandparent
	var ageOfUncaunt
	for i in global.familyTypes.size(): #runs through every family member
		if global.familyTypes[i] == "Mother": #if family member at index i is your mother
			global.familyAges.append(randi_range(18, 45)) #gives her a random age between 18 and 45
		elif global.familyTypes[i] == "Father": #if family member at index i is your father
			global.familyAges.append(randi_range(18, 45)) #men generally can father at older than around 45, unlike most women, but just for now, fathers will have the same
		#this has to happen now so the other multple family members' ages who rely on knowing the parents' ages can be generated (this does not have to happen for ageOfGrandparent and ageOfUncaunt:
		ageOfParent = global.familyTypes.find("Mother") #finds index of mother. This variable is used to keep track of the age of your parents without having to re-find it every time. .find() finds the first mother in the familyTypes array.
		#in case you have no mother:
		if ageOfParent == -1: #if you have NO mother; .find() returns -1 by default if it can't find anything
			ageOfParent = global.familyTypes.find("Father") #finds the first FATHER in the familyTypes array. If you have no mother, you MUST have a father.
		ageOfParent = global.familyAges[ageOfParent] #finds the age of the parent at the index of ageOfParent
		if global.familyTypes[i] == "Grandmother" || global.familyTypes[i] == "Grandfather": #if family member is a grandparent
			global.familyAges.append(randi_range(ageOfParent + 18, ageOfParent + 45)) #gives the grandparent an age between 18 and 45 years older than the first parent in the familyTypes array
		elif global.familyTypes[i] == "Brother" || global.familyTypes[i] == "Sister": #if family member is a sibling
			global.familyAges.append(randi_range(0, ageOfParent - 18)) #gives sibling an age between 18 and 45 years younger than the first parent in the array. Your parent would have had them between the ages of 18 and 45, so if they were 18, they would be 18 years younger than them, and if they were 45, they would be 45 years younger.
		elif global.familyTypes[i] == "Aunt" || global.familyTypes[i] == "Uncle": #if family member is a pibling (sidenote: pibling, or "parent's sibling" is a dumb gender-neutral term for aunt/uncle. We need a better one. I still stand by Uncaunt, a portmanteau of Uncle and Aunt coined by me. I am not biased, but that is the best one)
			ageOfGrandparent = global.familyTypes.find("Grandmother") #finds index of grandmother
			if ageOfGrandparent == -1: #if you have NO grandmother
				ageOfGrandparent = global.familyTypes.find("Grandfather") #if you have neither a grandmother nor a grandfather, this variable won't be used anyway. Don't lose any sleep over it.
			ageOfGrandparent = global.familyAges[ageOfGrandparent] #sets ageOfGrandparent to the actual age of the grandparent at index ageOfGrandparent (set just before) (it's confusing)
			global.familyAges.append(randi_range(ageOfParent, ageOfGrandparent - 18)) #gives uncaunt an age. They will be between the age of YOUR parent and 18 years younger than your grandparent (THEIR parent).
		elif global.familyTypes[i] == "Cousin": #if family member is a... cousin. Look, I don't know man, this is super self-explanatory
			ageOfUncaunt = global.familyTypes.find("Aunt") #finds index of aunt
			if ageOfUncaunt == -1: #if you have NO aunt
				ageOfUncaunt = global.familyTypes.find("Uncle") #again, if you have neither an aunt nor an uncle, this variable will not be used. Do not bother worrying about it.
			global.familyAges.append(randi_range(0, ageOfUncaunt - 18)) #gives cousin an age. They will be between 18 and 45 years younger than your Uncaunt (their parent).
	print(global.familyFirstNames)
	print(global.familyLastNames)
	print(global.familySexes)
	print(global.familyAges)
	print(global.familyTypes)
	print(global.familyRelationships)
	print("in total, you have " + str(global.familyTypes.size()) + " family members")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame #waits until the frame is fully loaded. Without this, the screen sometimes flashes gray while on this scene
	arrayCleaner()
	$loadingText.text = tips[randi_range(0, tips.size() - 1)] #picks a random tip to display. Must be size -1 because arrays are 0-indexed, meaning that the number of items in the array will be 1 more than the index of the last item.
	cleanLife()
	namePicker()
	epicStatChanges()
	familyGenerator() #:sob:
	print("life generated. starting...")
	get_tree().change_scene_to_file("res://pages/game_menu.tscn") #transport to main game page once loading is finished
