extends Node #author(s): Ethan Scott

#this is this game's global script. It is accessible from any script at any point. If you need to access or change a variable from here, for instance, firstName, in a different script, type "global." before the variable name: "global.firstName".


#engine
var versionNumber = ProjectSettings.get_setting("application/config/version") #change this in settings when working on an update to the next version number :) go to project -> project settings -> application -> config
var windowSize = [360, 640] #9:16 ratio - 360 x 640 is the default window size
var revent = [] #event IDs (can store multiple). begins with an age identifier (toddler, child, teenager, adult, elder, or "na" for not applicable) and ends with a unique number.
var currentLife = ""
var IDClicked = -1 #used to identify which relationship you're interacting with
var IDClickedType = "" #used to identify what type of relationship you're interacting with; can be either "family" or "misc"


#personal
var firstName = "" #both this and last name should begin with a capital
var lastName = ""
var age = 0 #in years
var sex = "" #will become either M for Male or F for Female during new life generation. For simplicity's sake I am not yet adding intersexuality, but I may later.
var joy = 0
var health = 0
var intellect = 0
var looks = 0
var logs = ""
var money = 0
#hidden stats - not shown to the player
var evality = 0 #on a scale from 0 - 100, how evil are you? i.e. how much joy do you derive from doing bad things, and what bad things are you capable of? higher is more.
var sexuality = "" #stored definitively, not relative to the sex of the player, i.e. if you're attracted to men, this value would be "M", if you're attracted to women, it would be "F", if you were attracted to both, it would be "Bi", and so on.


#rest-of-life-related
var crimes = []
var crimesSeverity = []
var schoolName = ""
var schoolLevel = -1 # -1 before you go to school, 0 if you've graduated school, 1 for primary, 2 for secondary (high school), 3 for tertiary. middle school, if implemented, would be 1.5.
var degrees = []
var fullTimeJob = ""
var fullTimeSalary = 0 #how much money you make annually from your full-time job
var partTimeJob = ""
var partTimeSalary = 0 #how much money you make annually from your part-time job
var workExperience = [] #every year you work a job or go to school, it is appended to this array. The number of times it appears is then used to calculate how many years of experience you have working a certain job or going to a certain school.
var schoolPerformance = 0 #how well are you doing at school? from 1 - 100
var partTimePerformance = 0
var fullTimePerformance = 0
var loans = [] #uh oh - can hold multiple loans at once - holds the total amount in dollars you owe
var loanPaybackDuration = [] #in how many years must the loan at its same index be fully paid back? Used to calculate how much you owe at the start of every year. The amount owed is then automatically deducted from your money total.
var loanInterest = [] #the percentage interest you owe on top of what you would pay back on your loans


#family
var familyFirstNames = []
var familyLastNames = []
var familyTypes = []
var familyAges = []
var familySexes = []
var familyRelationships = []
var familyStats = []
#dead
var deadFamilyFirstNames = []
var deadFamilyLastNames = []
var deadFamilyTypes = []
var deadFamilyAges = []
var deadFamilySexes = []
var deadFamilyRelationships = [] #how close you were with them when they died

#other (miscellaneous) relationships
var miscFirstNames = []
var miscLastNames = []
var miscTypes = []
var miscAges = []
var miscSexes = []
var miscRelationships = []
var miscStats = []
#dead
var deadMiscFirstNames = []
var deadMiscLastNames = []
var deadMiscTypes = []
var deadMiscAges = []
var deadMiscSexes = []
var deadMiscRelationships = [] #how close you were with them when they died

var possibleStats = ["money"] #relationship stats dictionary - the types match the index of their respective values.


#miscellaneous stuff that must be stored over multiple pages
#things that must be kept track of when inventing new people for events
var eventPersonFirstName = ""
var eventPersonLastName = ""
var eventPersonAge = ""
var eventPersonSex = ""
#other
var degreePicked = ""
var customLifeSaveDir = ""
var customLifeImportDir = ""


#keeping track (for achievements, use upon death, or otherwise)
var joyOverTime = [] #every time you age up, your current joy level is appended here. when you die, the average of all these values is calculated and you are told it.
var healthOverTime = []
var intellectOverTime = []
var looksOverTime = []
var causeOfDeath = ""
var XPQueued = 0 #the amount of XP that needs to be awarded when you die
var history = [] #keeps a log of what activities you've done this year. Cleared when aging up.


#testing variables - used in developer mode
var RAUE = true #RAUE is an acronym for Random Age Up Events. When true, events will randomly appear when aging up. When false, they will not.


#inter-life variables (non-life specific, saved into the game save file, persists across all lives)
var XP = 0
var level = 1 #increments when you reach the amount of XP you need to level up
var XPRequired = 500 #the amount of XP you need total to level up. Increases by 500 every level.


func statClamper(): #if stats are out of bounds (above or below their max/min value, usually 0/100 respectively), clamp them
	#personal
	if joy > 100:
		joy = 100
	elif joy < 0:
		joy = 0
	if health > 100:
		health = 100
	elif health < 0:
		health = 0
	if intellect > 100:
		intellect = 100
	elif intellect < 0:
		intellect = 0
	if looks > 100:
		looks = 100
	elif looks < 0:
		looks = 0
	if evality > 100:
		evality = 100
	elif evality < 0:
		evality = 0
	#rest-of-life-relatedd
	if schoolPerformance > 100:
		schoolPerformance = 100
	elif schoolPerformance < 0:
		schoolPerformance = 0
	if partTimePerformance > 100:
		partTimePerformance = 100
	elif partTimePerformance < 0:
		partTimePerformance = 0
	if fullTimePerformance > 100:
		fullTimePerformance = 100
	elif fullTimePerformance < 0:
		fullTimePerformance = 0


func cooldown(activity): #returns how many times you've done a certain thing this year already. This number can then be used to create a cooldown of sorts; if you've done something a million times this year, make it ineffective for once.
	var timesActivityAppeared = 0
	for i in history.size(): #runs through everything you've done this year
		if history[i] == activity: #if it's the activity we're looking for
			timesActivityAppeared += 1 #it has appeared one more time
	return timesActivityAppeared


func pronounGenerator(type, sex): #returns pronouns so you don't have to do it manually inside anything - can be one of three types: him (objective), his (possessive), he (personal), or boy (noun)
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


#savegame stuff
func lifeSerialiser(): #serialises every life-specific variable we need to save into a dictionary and then returns it
	var collinsDictionary = {
		#engine
		"versionNumber" : versionNumber,
		"revent" : revent,
		"RAUE" : RAUE,
		#personal
		"firstName" : firstName,
		"lastName" : lastName,
		"age" : age,
		"sex" : sex,
		"joy" : joy,
		"health" : health,
		"intellect" : intellect,
		"looks" : looks,
		"logs" : logs,
		"money" : money,
		"evality" : evality,
		"sexuality" : sexuality,
		#rest-of-life-related
		"crimes" : crimes,
		"crimesSeverity" : crimesSeverity,
		"schoolName" : schoolName,
		"schoolLevel" : schoolLevel,
		"degrees" : degrees,
		"fullTimeJob" : fullTimeJob,
		"fullTimeSalary" : fullTimeSalary,
		"partTimeJob" : partTimeJob,
		"partTimeSalary" : partTimeSalary,
		"workExperience" : workExperience,
		"schoolPerformance" : schoolPerformance,
		"partTimePerformance" : partTimePerformance,
		"fullTimePerformance" : fullTimePerformance,
		"loans" : loans,
		"loanPaybackDuration" : loanPaybackDuration,
		"loanInterest" : loanInterest,
		#family relationships
		"familyFirstNames" : familyFirstNames,
		"familyLastNames" : familyLastNames,
		"familyTypes" : familyTypes,
		"familyAges" : familyAges,
		"familySexes" : familySexes,
		"familyRelationships" : familyRelationships,
		"familyStats" : familyStats,
		#dead family
		"deadFamilyFirstNames" : deadFamilyFirstNames,
		"deadFamilyLastNames" : deadFamilyLastNames,
		"deadFamilyTypes" : deadFamilyTypes,
		"deadFamilyAges" : deadFamilyAges,
		"deadFamilySexes" : deadFamilySexes,
		"deadFamilyRelationships" : deadFamilyRelationships,
		#other relationships
		"miscFirstNames" : miscFirstNames,
		"miscLastNames" : miscLastNames,
		"miscTypes" : miscTypes,
		"miscAges" : miscAges,
		"miscSexes" : miscSexes,
		"miscRelationships" : miscRelationships,
		"miscStats" : miscStats,
		#dead other relationships
		"deadMiscFirstNames" : deadMiscFirstNames,
		"deadMiscLastNames" : deadMiscLastNames,
		"deadMiscTypes" : deadMiscTypes,
		"deadMiscAges" : deadMiscAges,
		"deadMiscSexes" : deadMiscSexes,
		"deadMiscRelationships" : deadMiscRelationships,
		#misc
		"eventPersonFirstName" : eventPersonFirstName,
		"eventPersonLastName" : eventPersonLastName,
		"eventPersonAge" : eventPersonAge,
		"eventPersonSex" : eventPersonSex,
		"degreePicked" : degreePicked,
		#keeping track
		"joyOverTime" : joyOverTime,
		"healthOverTime" : healthOverTime,
		"intellectOverTime" : intellectOverTime,
		"looksOverTime" : looksOverTime,
		"XPQueued" : XPQueued,
		"history" : history,
	}
	return collinsDictionary

func gameSerialiser(): #serialises every NON-life-specific variable we need to save into a dictionary and then returns it
	var cambridgeDictionary = {
		"windowSize" : windowSize,
		"currentLife" : currentLife,
		"XP" : XP,
		"level" : level,
		"XPRequired" : XPRequired,
	}
	return cambridgeDictionary

func getSaveLifeFileName(): #will return the unqiue file name, e.g. "Marsden-Gord-9"
	#checks the paths exist
	var dirPath = "user://spycarsinc/bls/lives/"
	if not DirAccess.dir_exists_absolute(dirPath):
		DirAccess.make_dir_recursive_absolute(dirPath) #if the paths don't exist, create them
	#has two save files - one for life-specific variables, and one for non-life-specific (game) variables.
	#unique file checking
	var lifeAnd = 0
	var uniqueLifeSaveName = false
	while uniqueLifeSaveName == false:
		if FileAccess.file_exists("user://spycarsinc/bls/lives/" + firstName + "-" + lastName + "-" + str(lifeAnd) + ".bls"): #if there is already a file with the same name (so it doesn't get overwritten against your will)
			lifeAnd += 1 #try incrementing the lifeAnd number that gets appended to the file name
		else: #if the file name is unique, and so writing to it will not overwrite another life
			uniqueLifeSaveName = true #stops loop; we have a valid file name
	return firstName + "-" + lastName + "-" + str(lifeAnd) #returns the unique file name

func directoryGetter(): #gets path to lives
	getSaveLifeFileName() #makes sure path exists
	return "user://spycarsinc/bls/lives/" #returns path

func saveGame(): #does the actual saving
	if currentLife != "": #if you currently HAVE a life to save
		var lifeSavePath = "user://spycarsinc/bls/lives/" + currentLife + ".bls" #the path on the user's device the save will be located - this save only stores the life-specific stuff that doesn't persist between lives (age, relationships, health...)
		if customLifeSaveDir != "": #if you're saving to a custom directory (i.e. you've been sent by importExportSaveFiles.gd
			lifeSavePath = customLifeSaveDir + "/" + currentLife + ".bls"
			customLifeSaveDir = "" #reset, that's all we needed the custom directory for
		if lifeSavePath == null:
			$confirmation.text = "Yuck! Failed to open file: " + str(FileAccess.get_open_error())
			return
		var lifeSaveFile = FileAccess.open(lifeSavePath, FileAccess.WRITE)
		lifeSaveFile.store_var(lifeSerialiser()) #overwrites the life save file with collinsDictionary from the lifeSerialiser() function above.
		lifeSaveFile.close() #closes file and saves changes
	var gameSavePath  = "user://spycarsinc/bls/game.bls" #this save stores all of the non-life-specific stuff that does persist between lives (achievements, XP and levels, DNA, etc...)
	var gameSaveFile = FileAccess.open(gameSavePath, FileAccess.WRITE)
	#and now do the rest
	gameSaveFile.store_var(gameSerialiser()) #overwrites the game save file with cambridgeDictionary from the gameSerialiser() function above.
	gameSaveFile.close() #closes file and saves changes

func loadGame(): #does the actual GAME loading
	if FileAccess.file_exists("user://spycarsinc/bls/game.bls") == true: #if the game save file exists, continue and load
		var gameSaveFile = FileAccess.open("user://spycarsinc/bls/game.bls", FileAccess.READ) #opens file to read
		if gameSaveFile:
			var dictionary = gameSaveFile.get_var()
			windowSize = dictionary["windowSize"]
			currentLife = dictionary["currentLife"]
			XP = dictionary["XP"]
			level = dictionary["level"]
			XPRequired = dictionary["XPRequired"]
			gameSaveFile.close() #closes file so it doesn't do anything weird
			print("hoorah, game load successful")
			print(currentLife)
			return #cease function function
	else: #file does not exist
		print("no game save file, will create a brand new one...")

func loadLife(): #does the actual LIFE loading
	var path = "user://spycarsinc/bls/lives/" + currentLife + ".bls"
	if customLifeImportDir != "": #if you have a custom file you would like to import from (see again importExportSaveFiles.gd)
		path = customLifeImportDir
		customLifeImportDir = ""
	if FileAccess.file_exists(path) == true: #if the life save file exists, continue and load
		var lifeSaveFile = FileAccess.open(path, FileAccess.READ) #opens file to read
		if lifeSaveFile: #if the file is valid
			var dictionary = lifeSaveFile.get_var()
			#engine
			revent = dictionary["revent"]
			RAUE = dictionary["RAUE"]
			#personal
			firstName = dictionary["firstName"]
			lastName = dictionary["lastName"]
			age = dictionary["age"]
			sex = dictionary["sex"]
			joy = dictionary["joy"]
			health = dictionary["health"]
			intellect = dictionary["intellect"]
			looks = dictionary["looks"]
			logs = dictionary["logs"]
			money = dictionary["money"]
			evality = dictionary["evality"]
			sexuality = dictionary["sexuality"]
			#rest-of-life-related
			crimes = dictionary["crimes"]
			crimesSeverity = dictionary["crimesSeverity"]
			schoolName = dictionary["schoolName"]
			schoolLevel = dictionary["schoolLevel"]
			degrees = dictionary["degrees"]
			fullTimeJob = dictionary["fullTimeJob"]
			fullTimeSalary = dictionary["fullTimeSalary"]
			partTimeJob = dictionary["partTimeJob"]
			partTimeSalary = dictionary["partTimeSalary"]
			workExperience = dictionary["workExperience"]
			schoolPerformance = dictionary["schoolPerformance"]
			partTimePerformance = dictionary["partTimePerformance"]
			fullTimePerformance = dictionary["fullTimePerformance"]
			loans = dictionary["loans"]
			loanPaybackDuration = dictionary["loanPaybackDuration"]
			loanInterest = dictionary["loanInterest"]
			#family relationships
			familyFirstNames = dictionary["familyFirstNames"]
			familyLastNames = dictionary["familyLastNames"]
			familyTypes = dictionary["familyTypes"]
			familyAges = dictionary["familyAges"]
			familySexes = dictionary["familySexes"]
			familyRelationships = dictionary["familyRelationships"]
			familyStats = dictionary["familyStats"]
			#dead family
			deadFamilyFirstNames = dictionary["deadFamilyFirstNames"]
			deadFamilyLastNames = dictionary["deadFamilyLastNames"]
			deadFamilyTypes = dictionary["deadFamilyTypes"]
			deadFamilyAges = dictionary["deadFamilyAges"]
			deadFamilySexes = dictionary["deadFamilySexes"]
			deadFamilyRelationships = dictionary["deadFamilyRelationships"]
			#misc relationships
			miscFirstNames = dictionary["miscFirstNames"]
			miscLastNames = dictionary["miscLastNames"]
			miscTypes = dictionary["miscTypes"]
			miscAges = dictionary["miscAges"]
			miscSexes = dictionary["miscSexes"]
			miscRelationships = dictionary["miscRelationships"]
			miscStats = dictionary["miscStats"]
			#dead misc
			deadMiscFirstNames = dictionary["deadMiscFirstNames"]
			deadMiscLastNames = dictionary["deadMiscLastNames"]
			deadMiscTypes = dictionary["deadMiscTypes"]
			deadMiscAges = dictionary["deadMiscAges"]
			deadMiscSexes = dictionary["deadMiscSexes"]
			deadMiscRelationships = dictionary["deadMiscRelationships"]
			#misc
			eventPersonFirstName = dictionary["eventPersonFirstName"]
			eventPersonLastName = dictionary["eventPersonLastName"]
			eventPersonAge = dictionary["eventPersonAge"]
			eventPersonSex = dictionary["eventPersonSex"]
			degreePicked = dictionary["degreePicked"]
			#keeping track
			joyOverTime = dictionary["joyOverTime"]
			healthOverTime = dictionary["healthOverTime"]
			intellectOverTime = dictionary["intellectOverTime"]
			looksOverTime = dictionary["looksOverTime"]
			XPQueued = dictionary["XPQueued"]
			history = dictionary["history"]
			lifeSaveFile.close() #closes file so it doesn't do anything weird
			print("hoorah, life load successful")
			get_tree().change_scene_to_file("res://pages/game_menu.tscn")
	else: #file does not exist
		print("no life save file... how did you even run this function if there's no... i-")


func loadList(path, splitter): #loads list of anything from a seperate file :) used mainly for names. thanks to GrayyGray for using this method originally in a fork
	return FileAccess.get_file_as_string(path).split(splitter) #items in the list are split up by commas followed by spaces
#lists end in a comma followed by a space so any useless data after it (i.e. a new line) is included as the last element, which is popped (removed) when this script is loaded. must be strictly typed as arrays because otherwise godot automatically makes the name arrays and other string arrays into "packed string arrays", which don't let you remove elements as far as I know, but are more memory-efficient than regular arrays. Trust me, I would use those if I could.

#global arrays that are loaded from external files
var tips : Array = loadList("res://data/tips.txt", " | ") #tips to be displayed on the screen during loading :) - items in THIS list are seperated by " | "
#names
var mFirstNames : Array = loadList("res://data/names/mFirstNames.txt", ", ") #loads list of masculine first names
var fFirstNames : Array = loadList("res://data/names/fFirstNames.txt", ", ") #feminine first names
var uFirstNames : Array = loadList("res://data/names/uFirstNames.txt", ", ") #unisex first names
var lastNames : Array = loadList("res://data/names/lastNames.txt", ", ") #dude just look at the variable name
var rareFirstNames : Array = loadList("res://data/names/rareFirstNames.txt", ", ") #only generated in pairs of first name and last name. Regular names roll once for a first name and again to pick a last name, whereas rare names only roll once and pick the corresponding first and last name. So picking "Rob" as a rare first name cannot result in the name "Rob Salad", it will always result in "Rob Ery" as they are both at the same index. This is to make seperating first and last names easier, but also preserve the rare name as originally intended.
var rareLastNames : Array = loadList("res://data/names/rareLastNames.txt", ", ") #Marl and ™ have only a first name. This will result in some weird behaviour, such as the player being called "Mr./Mrs.[blank]", but that is a sarcrifice I am willing to make.


func _ready() -> void: #when this is loaded for the first time (once when the game starts and never again while it's still running)
	#removes the last element of all IMPORTED arrays (from a txt file in res://data/), which SHOULD be occupied by dead space and no actual data
	tips.pop_back()
	mFirstNames.pop_back()
	fFirstNames.pop_back()
	uFirstNames.pop_back()
	lastNames.pop_back()
	rareFirstNames.pop_back()
	rareLastNames.pop_back()
