extends Node #author(s): Ethan Scott

#this is this game's global script. It is accessible from any script at any point. If you need to access or change a variable from here, for instance, firstName, in a different script, type "" before the variable name: "firstName".


#engine
var versionNumber = ProjectSettings.get_setting("application/config/version") #change this in settings when working on an update to the next version number :) go to project -> project settings -> application -> config
var windowSize = [360, 640] #9:16 ratio - 360 x 640 is the default window size
var revent = [] #event IDs (can store multiple). begins with an age identifier (toddler, child, teenager, adult, elder, or "na" for not applicable) and ends with a unique number.
var currentLife = ""
var IDClicked : int = -1 #used to identify which relationship you're interacting with
var IDClickedType = "" #used to identify what type of relationship you're interacting with; can be either "family" or "misc"
var importLegacySave = "" #you are sent to newRandomGame to import and load a legacy save. if, after all life variables are filled in, this does not equal "" (i.e. there is a path here), it will load the legacy save from the path provided.
var developerModePassword = "" #once you enter it correctly, you won't have to do it every time. It is saved here and run automatically.
var keyboardShortcutsEnabled = false #whether or not keyboard shortcuts are enabled. Only works on devices with a physical keyboard attatched. Disabled by default. This can be changed in settings.
var eventMemory = [] #a 2D array that holds more arrays that contain any extraneous data that events need to remember between several pages, isn't significant enough to warrant its own dedicated global variables, and too complex to be stored in the event ID.


#personal
var firstName = "" #both this and last name should begin with a capital
var lastName = ""
var age : int = 0 #in years
var sex = "" #will become either M for Male or F for Female during new life generation. For simplicity's sake I am not yet adding intersexuality, but I may later.
var joy : int = 0
var health : int = 0
var intellect : int = 0
var looks : int = 0
var logs : Array = []
var money : int = 0
#hidden stats - not shown to the player
var evality : int = 0 #on a scale from 0 - 100, how evil are you? i.e. how much joy do you derive from doing bad things, and what bad things are you capable of? higher is more.
var sexuality = "" #stored definitively, not relative to the sex of the player, i.e. if you're attracted to men, this value would be "M", if you're attracted to women, it would be "F", if you were attracted to both, it would be "Bi", and so on.


#rest-of-life-related
var crimes = []
var crimesSeverity = []
var crimeTime = [] #how many years in prison is each crime worth?
var criminalRecord = []
var criminalRecordSeverity = []
var prisonSentence = 0
var lawyers = [] #three laywers generated every new life that will be presented to you as options to hire if you ever go on a court trial. This array contains the names of the law firms. The lawyers here are in ascending order of quality and their indexes correspond with their respective matches in the lawyer array(s) below.
var lawyerCostMultiplier = [] #used to deduce the cost of hiring a certain lawyer -> crimeSeverityCalculator() * this[lawyerIndex]. The cost multiplier (this) goes up with e
var lawyerTierPicked : int = 0 #used to deduce quality of lawyer service provided
var multiplicativeArrestChance : float = 1 #a modifier to your chance of being arrested randomly for your crimes. 1 by default. Higher is a higher chance and lower is a lower chance, but your chances can never be lower than 0.1. Increased by 0.25 every year it's lower than 2 (if you have committed a crime).
var schoolName = ""
var schoolLevel : int = -1 # -1 before you go to school, 0 if you've graduated school, 1 for primary, 2 for secondary (high school), 3 for tertiary. middle school, if implemented, would be 1.5.
var schoolPerformanceTracker = []
var degrees = []
var degreeProficiency = [] #how good of work you did to get the degree with the matching index. This the average of your school performance per year you did the degree, from 0 - 100 (info from schoolPerformanceTracker).
var fullTimeJob = ""
var fullTimeSalary : int = 0 #how much money you make annually from your full-time job
var partTimeJob = ""
var partTimeSalary : int = 0 #how much money you make annually from your part-time job
var workExperience = [] #every year you work a job or go to school, it is appended to this array. The number of times it appears is then used to calculate how many years of experience you have working a certain job or going to a certain school.
var schoolPerformance : int = 0 #how well are you doing at school? from 1 - 100
var partTimePerformance : int = 0
var fullTimePerformance : int = 0
var loans = [] #uh oh - can hold multiple loans at once - holds the total amount in dollars you owe
var loanInitialValue = [] #stores the initial dollar amount of each current loan you've taken out
var loanPaybackDuration = [] #in how many years must the loan at its same index be fully paid back? Used to calculate how much you owe at the start of every year. The amount owed is then automatically deducted from your money total.
var loanInterest = [] #the percentage interest you owe on top of what you would pay back on your loans

#NPC relationships
var personFirstNames = []
var personLastNames = []
var personTypes = [] #mother/father/brother/sister/friend/girlfriend/boyfriend etc
var personAges = []
var personSexes = []
var personRelationships = []
var personUIDsUsed : int = 0
var personUIDs = [] #stores unique ID numbers for each NPC. Used when we have to keep track of EXACTLY the same person. Differs from their INDEX, accessed through other arrays, which can change if NPCs are removed. This stays consistent per person throughout their entire life. Each person's UID is entirely unique. personUIDsUsed is set to 0 at the start of a new life, and appended here before being incremented whenever a new person is added. A person's UID is popped upon their removal from other arrays, but their UID will never be used again. Use only when using indexes is insufficient. Most times it is fine, and in some cases even preferable, to simply use those.
var personStats = [] #a 2D array, meaning this is an array that contains other arrays. each element in this array is another array whose index corresponds to an NPC. Each element inside each nested array is a stat, whose element in that array corresponds to a definition in the personStatsDictionary.
var personStatsDictionary = ["joy"] #relationship stats dictionary - the types match the index of their respective values.
var personCategories = [] #can be family or misc
#dead
var deadPersonFirstNames = []
var deadPersonLastNames = []
var deadPersonTypes = []
var deadPersonAges = []
var deadPersonSexes = []
var deadPersonRelationships = [] #how close you were with them when they died
var deadPersonCause = [] #how did said person die
var deadPersonCategories = []


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
var XPQueued : int = 0 #the amount of XP that needs to be awarded when you die
var history = [] #keeps a log of what activities you've done this year. Cleared when aging up.
var intellectAtTimeOfCrime = []


#testing variables - used in developer mode
var RAUE = true #RAUE is an acronym for Random Age Up Events. When true, events will randomly appear when aging up. When false, they will not.


#inter-life variables (non-life specific, saved into the game save file, persists across all lives)
var XP : int = 0
var level : int = 1 #increments when you reach the amount of XP you need to level up
var XPRequired : int = 500 #the amount of XP you need total to level up. Increases by 500 every level.


func isBetween(x, minimum, maximum, inclusive): #checks if any variable (x) is between two values (floor is the lowest it will accept, ceil is the highest). If inclusive, if x is equal to the floor or ceil, it will still return true, if it is false, it will not.
	if inclusive == true:
		if x >= minimum && x <= maximum:
			return true
	elif inclusive == false:
		if x > minimum && x < maximum:
			return true
	return false #if true hasn't been returned yet, it's not between the two values


func statClamper(): #if stats are out of bounds (above or below their max/min value, usually 0/100 respectively), clamp them
	#personal
	if joy > 100:
		joy = 100
	elif joy < 0:
		joy = 0
	int(joy)
	if health > 100:
		health = 100
	elif health < 0:
		health = 0
	int(health)
	if intellect > 100:
		intellect = 100
	elif intellect < 0:
		intellect = 0
	int(intellect) #ha... haha... int... intellect... get it?
	if looks > 100:
		looks = 100
	elif looks < 0:
		looks = 0
	int(looks)
	if evality > 100:
		evality = 100
	elif evality < 0:
		evality = 0
	int(evality)
	#rest-of-life-related
	if multiplicativeArrestChance > 2:
		multiplicativeArrestChance = 2
	elif multiplicativeArrestChance < 0.1:
		multiplicativeArrestChance = 0.1
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
	#NPC-related
	for i in personTypes.size(): #runs through everyone you know
		if personRelationships[i] > 100:
			personRelationships[i] = 100
		elif personRelationships[i] < 0:
			personRelationships[i] = 0
		for x in personStats[i].size(): #runs through all of their stats
			var stats = personStats[x]
			if personStatsDictionary[x] == "joy":
				if stats[x] > 100:
					stats[x] = 100
				elif stats[x] < 0:
					stats[x] = 0


func cooldown(activity): #returns how many times you've done a certain thing this year already. This number can then be used to create a cooldown of sorts; if you've done something a million times this year, make it ineffective for once.
	var timesActivityAppeared = 0
	for i in history.size(): #runs through everything you've done this year
		if history[i] == activity: #if it's the activity we're looking for
			timesActivityAppeared += 1 #it has appeared one more time
	return timesActivityAppeared


func pronounGenerator(type, selectedSex): #returns pronouns so you don't have to do it manually inside anything - can be one of three types: him (objective), his (possessive), he (personal), or boy (noun)
	if type == "him":
		if selectedSex == "M": #if sex of person is male
			return "him"
		else: #if sex of person is female
			return "her"
	elif type == "his":
		if selectedSex == "M": #if male
			return "his"
		else: #if female
			return "hers"
	elif type == "he":
		if selectedSex == "M": #if male
			return "he"
		else: #if female
			return "she"
	elif type == "boy":
		if selectedSex == "M": #if male
			return "boy"
		else: #if female
			return "girl"
	elif type == "guy":
		if selectedSex == "M": #if male
			return "guy"
		else: #if female
			return "girl"
	elif type == "man":
		if selectedSex == "M": #if male
			return "man"
		else: #if female
			return "woman"
	return "what" #usually you can't get here unless there's an error


func NPCCreator(NPCsex, NPCfirstName, NPClastName, NPCage, NPCrelationship, NPCtype, NPCcategory, NPCstats): #creates an NPC from several custom perameters
	personSexes.append(NPCsex)
	personFirstNames.append(NPCfirstName)
	personLastNames.append(NPClastName)
	personAges.append(NPCage)
	personRelationships.append(NPCrelationship)
	personTypes.append(NPCtype)
	personCategories.append(NPCcategory)
	if NPCstats == "random":
		personStats.append([randi_range(0, 100)])
	personUIDs.append(personUIDsUsed)
	personUIDsUsed += 1
	XPQueued += 10

func NPCKiller(type, index): #kills an NPC. type can be either "kill" or "remove"
	#archival
	if type == "kill":
		deadPersonFirstNames.append(personFirstNames[index])
		deadPersonLastNames.append(personLastNames[index])
		deadPersonRelationships.append(personRelationships[index])
		deadPersonTypes.append(personTypes[index])
		deadPersonAges.append(personAges[index])
		deadPersonSexes.append(personSexes[index])
		XPQueued += 10
	#removal
	personFirstNames.remove_at(index)
	personLastNames.remove_at(index)
	personRelationships.remove_at(index)
	personTypes.remove_at(index)
	personAges.remove_at(index)
	personSexes.remove_at(index)
	personStats.remove_at(index)
	personUIDs.remove_at(index)
	XPQueued += 5


func commitCrime(crime : String, severity : int, time):
	crimes.append(crime)
	crimesSeverity.append(severity)
	intellectAtTimeOfCrime.append(intellect)
	crimeTime.append(time)


func sumCalculator(numbers): #calculates the sum of all the elements in any array
	var sum = 0
	for i in numbers.size():
		if numbers[i] is int:
			sum += numbers[i]
	return sum


func commaiser(number): #seperates big numbers by commas every 3 characters from the right
	var regex = RegEx.new()
	regex.compile("(?<=\\d)(?=(\\d{3})+(?!\\d))") #finds the spot between every 3 digits
	return regex.sub(str(number), ",", true)

func anIser(undoctoredProceedingWord): #an-iser. Returns "n " to be appended to "a" if the word you give it starts with a vowel, and " " if it doesn't. Useful in events where the word following "a" will vary; use this so you don't accidentally say "a electrician" or something dumb. There are some small exceptions: for example, if you feed this the word "one" it will flag it as needing an "an" before it, which it obviously doesn't. If you need this to be able to handle a special exception, please add it to the special exceptions or special negative exceptions array. Add it to the special exceptions if it doesn't start with a vowel and needs an "an", and add it to special negative exceptions if it DOES start with a vowel but only needs an "a".
	undoctoredProceedingWord = str(undoctoredProceedingWord) #turns the word we're working with into a string in case it's a number or something weird
	var proceedingWord = undoctoredProceedingWord.to_lower() #decapitalises the word you're testing, then saves it to a new variable so we can still use the original version later
	#first, check for words that DO start with vowels but still only need an "a"
	var specialNegativeExceptions = ["one"] #if the word starts with a vowel, but still shouldn't be prefixed with an "an", like "one"
	for i in specialNegativeExceptions.size(): #check for matches
		if proceedingWord == specialNegativeExceptions[i]:
			return "a " + undoctoredProceedingWord #gives you the correct grammar AND the proceeding word WITH unaltered capitalisation (the way you entered it into the function)
	#checks for words that start DO with vowels AND require an "an"
	var firstLetter = proceedingWord[0] #saves the first character in the word you're testing to a variable
	var trueIfFirstLetterIs = ["a", "e", "i", "o", "u", "8"]
	for i in trueIfFirstLetterIs.size(): #runs through every first character that would require an "an"
		if firstLetter == trueIfFirstLetterIs[i]: #checks if they do
			return "an " + undoctoredProceedingWord #if they do, return
	#last, checks for words that don't start with vowels, but still do require an "an" due to how they're pronounced
	var specialExceptions = ["18"] #if the word doesn't start with a vowel, check it against any special exceptions that still require an "an", like 18
	for i in specialExceptions.size(): #checks if any of them are a match
		if proceedingWord == specialExceptions[i]: #if it IS a match
			return "an " + undoctoredProceedingWord #return
	#if you made it here, no vowel pronounciation weirdness, normal word, return "a" :)
	return "a " + undoctoredProceedingWord


func intIser(theArray): #turns array elements into integers
	var intTheArray = []
	for i in theArray.size():
		intTheArray.append(int(theArray[i]))
	return intTheArray


func crimeTimeCalculator():
	var totalSentence = 0
	for i in crimeTime.size():
		if crimeTime[i] is int && totalSentence is int: #if it's not a life sentence yet and this crime doesn't warrant a life sentence
			totalSentence += crimeTime[i]
		elif str(crimeTime[i]) == "Life" && str(totalSentence) != "Life": #if it's not a life sentence yet but the crime being checked does warrant a life sentence
			totalSentence = "Life"
		#otherwise, you already have a life sentence, and there's no need to add to it
	return totalSentence


func takeOutLoan(amount : int, interest : int, paybackPeriod : int): #amount in dollars, interest as a percentage, and pacyback period in years
	global.loans.append(amount) #takes out the loan
	global.loanInitialValue.append(roundi(float(amount) / paybackPeriod))
	global.loanInterest.append(interest) #percentage annual interest
	global.loanPaybackDuration.append(paybackPeriod) #pay it back over the course of however many years


func prisonPreparer(sentenceLength): #does everything you need to prepare the player for prison; you still have to be physically sent there manually
	prisonSentence = sentenceLength
	for i in crimes.size():
		criminalRecord.append(crimes[i])
		criminalRecordSeverity.append(crimesSeverity[i])


func averageFinder(array): #finds the mean average of all integer elements in any array
	var combinedTotal = 0
	var allInts = []
	for i in array.size():
		if type_string(typeof(array[i])) == "int": #if this element is an integer
			allInts.append(array[i])
			combinedTotal += array[i]
	if allInts.size() > 0:
		return round(combinedTotal / allInts.size())
	else:
		return 0


#savegame stuff
func lifeSerialiser(): #serialises every life-specific variable we need to save into a dictionary and then returns it
	var collinsDictionary = {
		#engine
		"versionNumber" : versionNumber,
		"revent" : revent,
		"RAUE" : RAUE,
		"eventMemory" : eventMemory,
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
		"intellectAtTimeOfCrime" : intellectAtTimeOfCrime,
		"crimeTime" : crimeTime,
		"criminalRecord" : criminalRecord,
		"criminalRecordSeverity" : criminalRecordSeverity,
		"prisonSentence" : prisonSentence,
		"lawyers" : lawyers,
		"lawyerCostMultiplier" : lawyerCostMultiplier,
		"lawyerTierPicked" : lawyerTierPicked,
		"multiplicativeArrestChance" : multiplicativeArrestChance,
		"schoolName" : schoolName,
		"schoolLevel" : schoolLevel,
		"schoolPerformanceTracker" : schoolPerformanceTracker,
		"degrees" : degrees,
		"degreeProficiency" : degreeProficiency,
		"fullTimeJob" : fullTimeJob,
		"fullTimeSalary" : fullTimeSalary,
		"partTimeJob" : partTimeJob,
		"partTimeSalary" : partTimeSalary,
		"workExperience" : workExperience,
		"schoolPerformance" : schoolPerformance,
		"partTimePerformance" : partTimePerformance,
		"fullTimePerformance" : fullTimePerformance,
		"loans" : loans,
		"loanInitialValue" : loanInitialValue,
		"loanPaybackDuration" : loanPaybackDuration,
		"loanInterest" : loanInterest,
		#NPC relationships
		"personFirstNames" : personFirstNames,
		"personLastNames" : personLastNames,
		"personTypes" : personTypes,
		"personAges" : personAges,
		"personSexes" : personSexes,
		"personRelationships" : personRelationships,
		"personUIDsUsed" : personUIDsUsed,
		"personUIDs" : personUIDs,
		"personStats" : personStats,
		"personCategories" : personCategories,
		#dead NPCs
		"deadPersonFirstNames" : deadPersonFirstNames,
		"deadPersonLastNames" : deadPersonLastNames,
		"deadPersonTypes" : deadPersonTypes,
		"deadPersonAges" : deadPersonAges,
		"deadPersonSexes" : deadPersonSexes,
		"deadPersonRelationships" : deadPersonRelationships,
		"deadPersonCategories" : deadPersonCategories,
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
		"versionNumber" : versionNumber,
		"windowSize" : windowSize,
		"currentLife" : currentLife,
		"XP" : XP,
		"level" : level,
		"XPRequired" : XPRequired,
		"developerModePassword" : developerModePassword,
		"keyboardShortcutsEnabled" : keyboardShortcutsEnabled,
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
			developerModePassword = dictionary["developerModePassword"]
			keyboardShortcutsEnabled = dictionary["keyboardShortcutsEnabled"]
			gameSaveFile.close() #closes file so it doesn't do anything weird
			print("hoorah, game load successful")
			print(currentLife)
			return #cease function function
	else: #file does not exist
		print("no game save file, will create a brand new one...")

func loadLife(takeHome = true, base64life = ""): #does the actual LIFE loading
	var path = ""
	var dictionary = {}
	var lifeSaveFile
	if base64life == "": #if you're not loading from a base64 dictionary (see importLifeFromClipboard.gd)
		path = "user://spycarsinc/bls/lives/" + currentLife + ".bls"
		if customLifeImportDir != "": #if you have a custom file you would like to import from (see again importExportSaveFiles.gd)
			path = customLifeImportDir
			customLifeImportDir = ""
		if FileAccess.file_exists(path) == true: #if the life save file exists, continue and load
			lifeSaveFile = FileAccess.open(path, FileAccess.READ) #opens file to read
			if lifeSaveFile: #if the file is valid
				dictionary = lifeSaveFile.get_var()
		else: #file does not exist
			print("no life save file... how did you even run this function if there's no... i-")
			return "failed"
	else: #if you ARE loading from a base64 dictionary instead of a file (again, see importLifeFromClipboard.gd)
		dictionary = JSON.parse_string(Marshalls.base64_to_utf8(base64life)) #creates a dictionary of the de-encoded base64 save file to use below:
	#engine
	revent = dictionary["revent"]
	RAUE = dictionary["RAUE"]
	eventMemory = dictionary["eventMemory"]
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
	crimesSeverity = intIser(dictionary["crimesSeverity"])
	intellectAtTimeOfCrime = intIser(dictionary["intellectAtTimeOfCrime"])
	crimeTime = intIser(dictionary["crimeTime"])
	criminalRecord = dictionary["criminalRecord"]
	criminalRecordSeverity = intIser(dictionary["criminalRecordSeverity"])
	prisonSentence = dictionary["prisonSentence"]
	lawyers = dictionary["lawyers"]
	lawyerCostMultiplier = intIser(dictionary["lawyerCostMultiplier"])
	lawyerTierPicked = dictionary["lawyerTierPicked"]
	multiplicativeArrestChance = dictionary["multiplicativeArrestChance"]
	schoolName = dictionary["schoolName"]
	schoolLevel = dictionary["schoolLevel"]
	schoolPerformanceTracker = intIser(dictionary["schoolPerformanceTracker"])
	degrees = dictionary["degrees"]
	degreeProficiency = intIser(dictionary["degreeProficiency"])
	fullTimeJob = dictionary["fullTimeJob"]
	fullTimeSalary = dictionary["fullTimeSalary"]
	partTimeJob = dictionary["partTimeJob"]
	partTimeSalary = dictionary["partTimeSalary"]
	workExperience = dictionary["workExperience"]
	schoolPerformance = dictionary["schoolPerformance"]
	partTimePerformance = dictionary["partTimePerformance"]
	fullTimePerformance = dictionary["fullTimePerformance"]
	loans = dictionary["loans"]
	loanInitialValue = dictionary["loanInitialValue"]
	loanPaybackDuration = dictionary["loanPaybackDuration"]
	loanInterest = dictionary["loanInterest"]
	#NPC relationships
	personFirstNames = dictionary["personFirstNames"]
	personLastNames = dictionary["personLastNames"]
	personTypes = dictionary["personTypes"]
	personAges = intIser(dictionary["personAges"])
	personSexes = dictionary["personSexes"]
	personRelationships = intIser(dictionary["personRelationships"])
	personUIDsUsed = dictionary["personUIDsUsed"]
	personUIDs = intIser(dictionary["personUIDs"])
	personStats = dictionary["personStats"]
	personCategories = dictionary["personCategories"]
	#dead NPCs
	deadPersonFirstNames = dictionary["deadPersonFirstNames"]
	deadPersonLastNames = dictionary["deadPersonLastNames"]
	deadPersonTypes = dictionary["deadPersonTypes"]
	deadPersonAges = intIser(dictionary["deadPersonAges"])
	deadPersonSexes = dictionary["deadPersonSexes"]
	deadPersonRelationships = intIser(dictionary["deadPersonRelationships"])
	deadPersonCategories = dictionary["deadPersonCategories"]
	#misc
	eventPersonFirstName = dictionary["eventPersonFirstName"]
	eventPersonLastName = dictionary["eventPersonLastName"]
	eventPersonAge = dictionary["eventPersonAge"]
	eventPersonSex = dictionary["eventPersonSex"]
	degreePicked = dictionary["degreePicked"]
	#keeping track
	joyOverTime = intIser(dictionary["joyOverTime"])
	healthOverTime = intIser(dictionary["healthOverTime"])
	intellectOverTime = intIser(dictionary["intellectOverTime"])
	looksOverTime = intIser(dictionary["looksOverTime"])
	XPQueued = dictionary["XPQueued"]
	history = dictionary["history"]
	print("hoorah, life load successful")
	if base64life == "": #if you had to open a file to load this
		lifeSaveFile.close() #closes file so it doesn't do anything weird
	if takeHome == true: #if you're supposed to be taken home after this (true by default)
		get_tree().change_scene_to_file("res://pages/game_menu.tscn")


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
