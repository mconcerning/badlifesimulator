extends Node #author(s): Ethan Scott

##This is this game's global script. It is accessible from any script at any point. If you need to access or change a variable from here, for instance, firstName, in a different script, type "" before the variable name: "firstName".


#engine
var versionNumber = ProjectSettings.get_setting("application/config/version") ##Keeps track of the game version - change this in settings when working on an update to the next version number :) go to project -> project settings -> application -> config
var windowSize = [360, 640] ##Stores the window dimensions the game should resize to fit when the game first loads. 9:16 ratio - 360 x 640 is the default window size.
var revent = [] ##Event IDs (can store multiple). For random events, the ID begins with an age identifier (toddler, child, teenager, adult, elder, or "na" for not applicable) and ends with a unique number. For non-random events, the ID could be any name that is uniquely identifying. 
var currentLife = ""
var IDClicked : int = -1 ##Used to identify which relationship you're interacting with; also used for job application
var IDClickedType = "" ##Used to identify what type of relationship you're interacting with; can be either "family" or "misc"
var importLegacySave = "" ##You are sent to newRandomGame to import and load a legacy save. if, after all life variables are filled in, this does not equal "" (i.e. there is a path here), it will load the legacy save from the path provided.
var developerModePassword = "" ##Once you enter it correctly, you won't have to do it every time. It is saved here and run automatically.
var keyboardShortcutsEnabled = false ##Whether or not keyboard shortcuts are enabled. Only works on devices with a physical keyboard attatched. Disabled by default. This can be changed in settings.
var dangerousKeyboardShortcuts = false ##Must also have regular keyboard shortcuts enabled. Enables risky global shortcuts that are too dangerous for the general public to have access to, a la ctrl + shift + h letting you rerandomise all luck in events - previously less able to be done, as you had to restart the entire game. This setting is only enablable in developer mode and recommended exclusively for developers, testers, and power users. See global script function for unhandled input for more information.
var bigMailto = false ##When enabled, increases the maximum character length for the mailto link when sending yourself a save file via email.
var eventMemory = [] ##An array that holds any extraneous data that events need to remember between several pages, isn't significant enough to warrant its own dedicated global variables, and too complex to be stored in the event ID.


#personal
var firstName = "" ##Your first name. Both this and last name should begin with a capital letter.
var lastName = ""
var age : int = 0 ##Age in years
var sex = "" ##Will become either M for Male or F for Female during new life generation. For simplicity's sake I am not yet adding intersexuality and other stuff, but I may later.
var joy : int = 0
var health : int = 0
var intellect : int = 0
var looks : int = 0
var logs : Array = []
var money : int = 0
#hidden stats - not shown to the player
var evality : int = 0 ##On a scale from 0 - 100, how evil are you? i.e. how much joy do you derive from doing bad things, and what bad things are you capable of? Higher is more.
var sexuality = "" ##Stored definitively, not relative to the sex of the player, i.e. if you're attracted to men, this value would be "M", if you're attracted to women, it would be "F", if you were attracted to both, it would be "Bi", and so on.


#rest-of-life-related
var jobOpenings = [] ##Holds all the full-time jobs available to apply for this year. Index 0 is job name, 1 is salary, 2 is qualifications, 3 is effects... See newJobOpenings() for more info.
var partTimeJobOpenings = [] ##Holds all the part-time jobs available to apply for this year. Index 0 is job name, 1 is hourly pay, 2 is weekly hours... See newJobOpenings() for more info.
var crimes = []
var crimesSeverity = []
var crimeTime = [] ##How many years in prison is each crime worth?
var criminalRecord = []
var criminalRecordSeverity = []
var prisonSentence = 0
var lawyers = [] ##Three laywers generated every new life that will be presented to you as options to hire if you ever go on a court trial. This array contains the names of the law firms. The lawyers here are in ascending order of quality and their indexes correspond with their respective matches in the lawyer array(s) below.
var lawyerCostMultiplier = [] ##Used to deduce the cost of hiring a certain lawyer -> crimeSeverityCalculator() * this[lawyerIndex]. The cost multiplier (this) goes up with e
var lawyerTierPicked : int = 0 ##Used to deduce quality of lawyer service provided
var multiplicativeArrestChance : float = 1 ##A modifier to your chance of being arrested randomly for your crimes. 1 by default. Higher is a higher chance and lower is a lower chance, but your chances can never be lower than 0.1. Increased by 0.25 every year it's lower than 2 (if you have committed a crime).
var schoolName = ""
var schoolLevel : int = -1 ##-1 before you go to school, 0 if you've graduated school, 1 for primary, 2 for secondary (high school), 3 for tertiary. Middle school, if implemented, would be 1.5.
var schoolPerformanceTracker = []
var degrees = []
var degreeProficiency = [] ##How good of work you did to get the degree with the matching index. This the average of your school performance per year you did the degree, from 0 - 100 (info from schoolPerformanceTracker).
var licences = [] ##Contains your licences, such as a driver's licence, gun licence, etc.
var certificates = [] ##Contains your certificate qualifications, such as a cert in plumbery, electricity, etc.
var failedCertificates = [] ##Contains every certificate you have failed.
var incomeTax = 30 ##How much you are taxxed on your income, expressed as a percentage.
var fullTimeJob = "" ##The name of your full-time job. "" (blank) if you don't have one.
var fullTimeSalary : int = 0 ##How much money you make annually from your full-time job
var partTimeJob = "" ##The name of your part-time job. "" (blank) if you don't have one.
var partTimeRate : int = 0 ##How much money you make per hour from your part-time job
var partTimeHours : int = 0 ##How many hours per annum you work part-time
var partTimeWorkWeeksPerAnnum : int = 48 ##How many weeks of the year do you work part-time? 48 by default; there's technically closer to ~52 weeks in a year, but this is supposed to factor in days off and other stuff.
var workExperience = [] ##Every year you work a job or go to school, it is appended to this array. The number of times it appears is then used to calculate how many years of experience you have working a certain job or going to a certain school.
var schoolPerformance : int = 0 ##How well are you doing at school? from 1 - 100
var partTimePerformance : int = 0
var fullTimePerformance : int = 0
var fullTimeEffectJoy = 0
var fullTimeEffectHealth = 0
var fullTimeEffectIntellect = 0
var fullTimeEffectLooks = 0
var fullTimeEffectEvality = 0
var loans = [] ##Uh oh - can hold multiple loans at once - holds the total amount in dollars you owe
var loanInitialValue = [] ##Stores the initial dollar amount of each current loan you've taken out
var loanPaybackDuration = [] ##In how many years must the loan at its same index be fully paid back? Used to calculate how much you owe at the start of every year. The amount owed is then automatically deducted from your money total.
var loanInterest = [] ##The percentage interest you owe on top of what you would pay back on your loans

#NPC relationships
var personFirstNames = []
var personLastNames = []
var personTypes = [] ##Mother/father/brother/sister/friend/girlfriend/boyfriend etc.
var personAges = []
var personSexes = []
var personRelationships = []
var personUIDsUsed : int = 0
var personUIDs = [] ##Stores unique ID numbers for each NPC. Used when we have to keep track of EXACTLY the same person. Differs from their INDEX, accessed through other arrays, which can change if NPCs are removed. This stays consistent per person throughout their entire life. Each person's UID is entirely unique. personUIDsUsed is set to 0 at the start of a new life, and appended here before being incremented whenever a new person is added. A person's UID is popped upon their removal from other arrays, but their UID will never be used again. Use only when using indexes is insufficient. Most times it is fine, and in some cases even preferable, to simply use those.
var personStats = [] ##An array that contains other arrays. Each element in this array is another array whose index corresponds to an NPC. Each element inside each nested array is a stat, whose element in that array corresponds to a definition in the personStatsDictionary.
var personStatsDictionary = ["Joy", "Health", "Intellect", "Looks", "Evality"] ##Relationship stats dictionary - the types match the index of their respective values.
var personCategories = [] ##Can be either family or misc
#dead
var deadPersonFirstNames = []
var deadPersonLastNames = []
var deadPersonTypes = []
var deadPersonAges = []
var deadPersonSexes = []
var deadPersonRelationships = [] ##How close you were with them when they died
var deadPersonCause = [] ##How did said person die
var deadPersonCategories = []
var deadPersonRecency = [] ##Saves your age here at the year of their death - this is then subtracted from your age now to determine how long ago they died.


#miscellaneous stuff that must be stored over multiple pages
#things that must be kept track of when inventing new people for events
var eventPersonFirstName = ""
var eventPersonLastName = ""
var eventPersonAge = ""
var eventPersonSex = ""
#other
var degreePicked = ""
var degreePickedCost = ""
var degreePickedLoanDuration = 0
var degreePickedLoanInterest = 0
var customLifeSaveDir = ""
var customLifeImportDir = ""
var customGameSaveDir = ""
var customGameImportDir = ""


#keeping track (for achievements, use upon death, or otherwise)
var joyOverTime = [] ##Every time you age up, your current joy level is appended here. when you die, the average of all these values is calculated and you are told it.
var healthOverTime = []
var intellectOverTime = []
var looksOverTime = []
var causeOfDeath = ""
var XPQueued : int = 0 ##The amount of XP that needs to be awarded when you die
var history = [] ##Keeps a log of what activities you've done this year. Cleared when aging up.
var intellectAtTimeOfCrime = []


#testing variables - used in developer mode
var RAUE = true ##RAUE is an acronym for Random Age Up Events. When true, events will randomly appear when aging up. When false, they will not.


#inter-life variables (non-life specific, saved into the game save file, persists across all lives)
var XP : int = 0
var level : int = 1 ##Increments when you reach the amount of XP you need to level up
var XPRequired : int = 1000 ##The amount of XP you need total to level up. Increases by 1,000 every level - these calculations are made when you die (death.gd).


func isBetween(x : float, minimum : float = 0, maximum : float = 1, inclusive = true): ##Checks if any variable (x) is between two values (floor is the lowest it will accept, ceil is the highest). If inclusive, if x is equal to the floor or ceil, it will still return true, if it is false, it will not.
	if inclusive == true:
		if x >= minimum && x <= maximum:
			return true
	elif inclusive == false:
		if x > minimum && x < maximum:
			return true
	return false #if true hasn't been returned yet, it's not between the two values


func customClamp(value, minim : float = 0, maxim : float = 100): ##"Clamps" any value to between a minimum and maximum; if it is below the minimum, this makes it equal the minimum, and if it is above the maximum, this makes it equal the maximum. Then returns the edited value. Minimum and maximum are 0 and 100 by default.
	var originalType = ""
	if value is int:
		originalType = "int"
	elif value is float:
		originalType = "float"
	if value > maxim:
		value = maxim
	elif value < minim:
		value = minim
	if originalType == "int":
		return roundi(value)
	elif originalType == "float":
		return float(value)

func statClamper(): ##If stats are out of bounds (above or below their max/min value, usually 0/100 respectively), clamps them.
	#personal
	joy = customClamp(joy)
	health = customClamp(health)
	intellect = customClamp(intellect)
	looks = customClamp(looks)
	evality = customClamp(evality)
	#rest-of-life-related
	multiplicativeArrestChance = customClamp(multiplicativeArrestChance, 0.1, 2)
	schoolPerformance = customClamp(schoolPerformance)
	partTimePerformance = customClamp(partTimePerformance)
	fullTimePerformance = customClamp(fullTimePerformance)
	#NPC-related
	for i in personTypes.size(): #runs through everyone you know
		personRelationships[i] = customClamp(personRelationships[i])
		for x in personStats[i].size(): #runs through all of their stats
			var dict = personStatsDictionary[x]
			if dict == "Joy" || dict == "Health" || dict == "Intellect" || dict == "Looks" || dict == "Evality": #if the stat needs to be clamped
				personStats[i][x] = customClamp(personStats[i][x])


func cooldown(activity): ##Returns how many times you've done a certain thing this year already using your history. This number can then be used to create a cooldown of sorts; if you've done something a million times this year, make it ineffective for once. This function only works if you make sure to actively append to history when things happen. NOTE: The exact same function can be achieved with the built-in .count("value") used on history (global.history.count(x)).
	var timesActivityAppeared = history.count(activity)
	return timesActivityAppeared


func pronounGenerator(type, selectedSex): ##Returns pronouns so you don't have to do it manually inside anything - can be one of three types: him (objective), his (possessive), he (personal), or boy (noun). Also accepts guy and man as types (returning girl and woman for women).
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
	return "what" #usually you can't get here unless you typed something wrong


func NPCStatsGenerator(): ##Generates and returns a fully random stats array for a new NPC.
	#Index 0 = Joy, 1 = Health, 2 = Intellect, 3 = Looks, 4 = Evality
	var stats = [randi_range(0, 100), randi_range(10, 100), randi_range(10, 95), randi_range(0, 100), randi_range(0, 100)]
	return stats

func NPCCreator(NPCsex : String, NPCfirstName : String, NPClastName : String, NPCage : int, NPCrelationship : int, NPCtype : String, NPCcategory : String, NPCstats = "random"): ##Creates an NPC from several custom perameters. NPCtype can be either "family" or "misc". If NPCstats is "random", this fills their stats in with random values.
	personSexes.append(NPCsex)
	personFirstNames.append(NPCfirstName)
	personLastNames.append(NPClastName)
	personAges.append(NPCage)
	personRelationships.append(NPCrelationship)
	personTypes.append(NPCtype)
	personCategories.append(NPCcategory)
	if NPCstats == "random": #if you want to randomly generate stats
		personStats.append(NPCStatsGenerator())
	else: #if you have specified stats to use
		personStats.append(NPCstats)
	personUIDs.append(personUIDsUsed)
	personUIDsUsed += 1
	XPQueued += 10

func NPCKiller(type : String, index : int, deathCause : String = "Specify if killing"): ##Kills an NPC. Type can be either "kill" or "remove"; "kill" literally kills them and "remove" simply rids them from your relationships, i.e. when you unfriend someone. Specify a cause of death when killing.
	#archival
	if type == "kill":
		deadPersonFirstNames.append(personFirstNames[index])
		deadPersonLastNames.append(personLastNames[index])
		deadPersonRelationships.append(personRelationships[index])
		deadPersonTypes.append(personTypes[index])
		deadPersonAges.append(personAges[index])
		deadPersonSexes.append(personSexes[index])
		deadPersonCategories.append(personCategories[index])
		deadPersonRecency.append(age)
		deadPersonCause.append(deathCause)
		revent.append("relationship-deathnotif") #notify the player that someone just died
		eventMemory.append(deadPersonTypes.size() - 1) #we need to get just the index of the newly-dead person on its own later
		eventMemory.append(customClamp(max(6, (roundi(float(global.personRelationships[index]) / 2)) + randi_range(-5, 5)))) #how much joy you will lose upon finding out they died (your relationship with them divided by two, plus a random amount from -5 to 5.
		XPQueued += 20
	#removal
	personFirstNames.remove_at(index)
	personLastNames.remove_at(index)
	personRelationships.remove_at(index)
	personTypes.remove_at(index)
	personAges.remove_at(index)
	personSexes.remove_at(index)
	personCategories.remove_at(index)
	personStats.remove_at(index)
	personUIDs.remove_at(index)
	XPQueued += 5


func sumCalculator(numbers): ##Calculates the sum of all the elements in any array.
	var sum = 0
	for i in numbers.size():
		if numbers[i] is int:
			sum += numbers[i]
	return sum


func commaiser(number): ##Seperates big numbers by commas every 3 characters from the right.
	var regex = RegEx.new()
	regex.compile("(?<=\\d)(?=(\\d{3})+(?!\\d))") #finds the spot between every 3 digits
	return regex.sub(str(number), ",", true)

func anIser(undoctoredProceedingWord): ##An-iser. Returns "an " + word if the word you give it starts with a vowel, and "a " + word if it doesn't. Useful in events where the word following "a" will vary; use this so you don't accidentally say "a electrician" or something dumb. There are some small exceptions: for example, if you feed this the word "one" it will flag it as needing an "an" before it, which it doesn't. If you need this to be able to handle a special exception, please add it to the special exceptions or special negative exceptions array contained within this function. Add it to the special exceptions if it doesn't start with a vowel and needs an "an", and add it to special negative exceptions if it DOES start with a vowel but only needs an "a".
	undoctoredProceedingWord = str(undoctoredProceedingWord) #turns the word we're working with into a string in case it's a number or something weird
	var proceedingWord = undoctoredProceedingWord.to_lower() #decapitalises the word you're testing, then saves it to a new variable so we can still use the original version later
	#if we're anIsing a dollar amount, get rid of the dollar sign
	if proceedingWord[0] == "$":
		proceedingWord = proceedingWord.substr(1) #only look at the string from the second character (the character after the dollar sign) onwards
	#if the string we're testing contains multiple words, only test the first one; this will be the only word requiring the correct "a" or "an". Seperating into only the first word makes sure special exceptions work correctly.
	if proceedingWord.contains(" "): #if the string given contains a space
		var stillGoing = true
		for i in proceedingWord.length(): #check every character individually
			if stillGoing == true: #until we're told to stop when stillGoing is set to false
				if proceedingWord[i] == " ": #if this character is a space
					proceedingWord = proceedingWord.left(i) #makes the proceeding word only the characters leading up to the space (not including it)
					stillGoing = false #stop the loop
	#first, check for words that DO start with vowels but still only need an "a"
	var specialNegativeExceptions = ["one", "university"] #if the word starts with a vowel, but still shouldn't be prefixed with an "an", like "one"
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


func intIser(theArray, nestedArray : bool = false): ##Turns array elements into integers. Set nestedArray to true if the array given contains other arrays that contain the elements you want to integer-ise.
	if nestedArray == true:
		var intTheNestedArray = []
		for i in theArray.size():
			intTheNestedArray.append([])
			for x in theArray[i].size():
				intTheNestedArray[i].append(int(theArray[i][x]))
		return intTheNestedArray
	var intTheArray = []
	for i in theArray.size():
		intTheArray.append(int(theArray[i]))
	return intTheArray


func icap(word): ##Short for Initial Capitalisation. Capitalises the first letter of any word.
	if word.length() < 2: #if the word is 1 (or 0) characters long, just capialise the whole thing
		word = word.to_upper
	else: #otherwise, if the word is multiple characters long, capitalise the first character
		word = word[0].to_upper() + word.substr(1)
	return word


func takeOutLoan(amount : int, interest : int, paybackPeriod : int): ##Takes out a loan. Perameters are: amount in dollars, interest as a percentage, and payback period in years.
	loans.append(amount) #takes out the loan
	loanInitialValue.append(roundi(float(amount) / paybackPeriod))
	loanInterest.append(interest) #percentage annual interest
	loanPaybackDuration.append(paybackPeriod) #pay it back over the course of however many years


func schoolRemove(): ##If you are in school, removes you from your school. Use this when getting expelled/kicked out or dropping out. Does not prepare an event about how you left; you will need to do that seperately.
	#you can keep your PROGRESS in school, including in university, so you can resume your progress as soon as you get out
	schoolName = ""
	schoolLevel = 0 #Lets you become full-time employed (yes, even if you are in primary school, STILL NOT MAKING CHILD LABOUR A THING, BY THE WAY), albeit without a diploma/the degree you picked.


var allJobs = [] ##All full-time jobs that exist. Fills upon starting a new life or aging up.

var allJobSalaries = [] ##A list of all full-time salaries. This is saved in your life save file instead of allJobs since the randomly-generated salary is the only thing that needs to kept track of.

var allPartTimeJobs = [] ##All part-time jobs that exist. Like allJobs, this fills upon starting a new life or aging up.

var allPartTimeJobSalaries = [] ##A list of all part-time salaries. This is saved in your life save file instead of allPartTimeJobs since the randomly-generated salary is the only thing that needs to kept track of.

func newJobOpenings(initialiseOnly = false): ##Creates a set of new job openings from the list of possible jobs. Used when creating a new life or aging up. If initialise equals true, this won't randomise job openings and will only fill in the allJobs and all partTimeJobs arrays.
	var newFullTimeJobOpenings = [["Primary school teacher", randi_range(850, 920) * 100, "High school diploma, 70+ intellect", "None"], ["High school teacher", randi_range(900, 1040) * 100, "Any University degree", "- 2 joy"], ["University professor", randi_range(2100, 2300) * 100, "Education + any second degree", "+ 4 intellect"], ["Public defender", randi_range(850, 1000) * 100, "Law degree", "- 4 joy, + 2 intellect"], ["Apprentice lawyer", randi_range(1220, 1300) * 100, "Law degree (65+ proficiency)", "- 4 joy, + 3 intellect"], ["Lawyer", randi_range(1800, 2100) * 100, "Law degree, 7+ yrs experience as apprentice", "- 5 joy, + 5 intellect"], ["Fast food worker", randi_range(490, 530) * 100, "Age 16+", "- 3 joy"], ["Fast food manager", randi_range(560, 620) * 100, "4+ yrs experience as worker, 60+ intellect, 25 yrs or older", "- 5 joy"], ["Retail worker", randi_range(425, 550) * 100, "High school diploma", "- 2 joy"], ["Apprentice logo designer", randi_range(600, 680) * 100, "Graphic design degree", "+ 3 joy"], ["Logo designer", randi_range(820, 900) * 100, "Graphic design degree, 6+ yrs experience as apprentice", "+ 4 joy"], ["Jr. business consultant", randi_range(750, 850) * 100, "Business degree", "+ 3 intellect"], ["Business consultant", randi_range(1100, 1250) * 100, "Business degree, 8+ yrs experience as Jr., 75+ intellect", "+ 5 intellect"], ["Sanitation worker", randi_range(510, 540) * 100, "High school diploma", "- 7 health"], ["Salt technician", randi_range(740, 810) * 100, "High school diploma, 70+ health", "+ 3 looks"], ["Exorcist", randi_range(350, 380) * 100, "High school diploma", "+ 6 joy"], ["Plumber", randi_range(850, 920) * 100, "High school diploma, Cert. in Plumbery", "- 1 health"], ["Electrician", randi_range(1100, 1190) * 100, "Engineering degree, Cert. in Electrical engineering", "None"], ["Astrophysicist", randi_range(1000, 1050) * 100, "Physics degree", "+ 2 intellect"], ["Cook", randi_range(760, 800) * 100, "3+ yrs experience as Kitchen hand, High school diploma", "- 1 Joy"], ["Head chef", randi_range(880, 920) * 100, "8+ yrs experience as Cook", "- 1 Joy, - 1 Health"]] ##Randomises which jobs are available for application. Salaries are within a randomised range depending on the job. The salary is calculated by generating a random number and multiplying it by 100. A 3-digit random number would produce a 5-figure salary (tens of thousands of dollars), a 4-digit number would produce a 6-figure salary, and so on. The multiplication results in salaries rounded to hundred of dollars.
	var newPartTimeOpenings = [["Lifeguard", randi_range(21, 25), randi_range(18, 24), "Age 18+, 75+ health"], ["Kitchen hand", randi_range(24, 27), randi_range(28, 34), "High school diploma"]] ##An array of arrays. Randomises which part-time jobs are available. The first index (0) of each array is the job name, the second index (1) is the hourly pay rate, the third index (2) is how many hours you'd work per week, and the fourth index (3) is any additional requirements. In Australia, the hours would usually be about 15 - 35, but to qualify as part-time, it MUST be less than 38/week.
	allJobs = newFullTimeJobOpenings #before the number of jobs is cut and the order is randomised, create the global dictionary of all jobs
	allPartTimeJobs = newPartTimeOpenings #do the same for part-time jobs
	if initialiseOnly == true: #if we're only here to initialise the allJobs arrays, do the above and then stop
		return
	#full-time jobs
	jobSavers("save", "full") #saves the randomly-generated job salaries based on allJobs
	newFullTimeJobOpenings.shuffle() #randomises order of the jobs. Used in tandem with the below, randomly limits which jobs are available.
	while newFullTimeJobOpenings.size() > 25: #limits the number of job openings on any given year to 25; these 25 could be any
		newFullTimeJobOpenings.pop_back()
	#sort jobs in descending order by salary
	#i'm not doing sort_custom with a lambda. What the hell is a lambda?? Why call it that??
	newFullTimeJobOpenings.sort_custom(func(a, b): return a[1] > b[1]) #fine
	jobOpenings = newFullTimeJobOpenings
	#part-time job openings
	jobSavers("save", "part") #saves the randomly-generated job salaries based on allPartTimeJobs
	newPartTimeOpenings.shuffle() #randomises order of the jobs
	while newPartTimeOpenings.size() > 10: #limits the number of part time jobs available to 10; removes any jobs beyond those 10 in the randomised order array
		newPartTimeOpenings.pop_back()
	newPartTimeOpenings.sort_custom(func(a, b): return a[1] > b[1]) #FINE, I'LL DO A LAMBDA, CALM DOWN
	partTimeJobOpenings = newPartTimeOpenings

func jobSavers(saveLoad : String, timeType : String): ##saves (or loads) the list of all jobs, both full-time and part-time, to/from global.allJobSalaries and global.allPartTimeJobSalaries. These special salary arrays can then be saved to and loaded from your life and swapped in place of the auto-generated salaries in allJobs and allPartTimeJobs. This makes the save file smaller, since we only have to store the jobs' salaries (since those are the only things that change), not all the information about them. saveLoad can be either "save" or "load"; "save" if we want to be able to save the jobs' salaries, and "load" if we want to load the jobs' saved salaries. timeType can be either "full" or "part", for full-time or part-time. You must use global.loadLife() before using the load function and you must use global.saveGame() sometime after using the save function if you want this to have any effect.
	if saveLoad == "save": #if we want to be able to save the jobs' salaries
		if timeType == "full":
			allJobSalaries = [] #resets the job salaries we save so we're not just infinitely appending and creating a horrible nightmare file size cancer (i figured out this has to be here the hard way)
			for i in allJobs.size():
				allJobSalaries.append(allJobs[i][1]) #puts the full-time job's salary in the allJobSalaries array
		elif timeType == "part":
			allPartTimeJobSalaries = [] #resets the job salaries for the same reason as with full-time jobs
			for i in allPartTimeJobs.size():
				allPartTimeJobSalaries.append(allPartTimeJobs[i][1]) #puts the part-time job's salary in the allPartTimeJobSalaries array
	elif saveLoad == "load": #if we want to load the jobs' saved salaries
		newJobOpenings(true) #initialise the allJobs arrays for both full-time and part-time jobs
		if timeType == "full":
			#allJobs = newJobOpenings("return full-time") #has to get the list of all jobs first because allJobs does not equal it yet
			for i in allJobs.size():
				allJobs[i][1] = allJobSalaries[i] #substitutes the salary there with the salary saved
		elif timeType == "part":
			for i in allPartTimeJobs.size():
				allPartTimeJobs[i][1] = allPartTimeJobSalaries[i] #substitutes the salary there with the salary saved

func fullTimeEffectInitialiser(Fjoy = 0, Fhealth = 0, Fintellect = 0, Flooks = 0, Fevality = 0): ##Sets every full-time job effects variable. Leaving any field blank will set them to 0 (no effect).
	fullTimeEffectJoy = Fjoy
	fullTimeEffectHealth = Fhealth
	fullTimeEffectIntellect = Fintellect
	fullTimeEffectLooks = Flooks
	fullTimeEffectEvality = Fevality

func findFullTimeJob(job : String): ##Returns the index of any full-time job in the allJobs array from its name.
	for i in allJobs.size():
		if allJobs[i][0] == job:
			return i

func findPartTimeJob(job : String): ##Returns the index of any part-time job in the allPartTimeJobs array from its name.
	for i in allPartTimeJobs.size():
		if allPartTimeJobs[i][0] == job:
			return i

func removeFullTimeJob(): ##Clears your full-time job. Use this when quitting or getting fired.
	#resets all job effects
	fullTimeEffectInitialiser() #sets every job effect to 0
	#removes the job
	fullTimeJob = ""
	fullTimeSalary = 0
	fullTimePerformance = 0

func removePartTimeJob(): ##Clears your part-time job. Use this when quitting or getting fired.
	partTimeJob = ""
	partTimeHours = 0
	partTimeRate = 0
	partTimePerformance = 0


func partTimeSalary(): ##Calculates how much money you should make for working part-time for one year.
	return partTimeRate * partTimeHours * partTimeWorkWeeksPerAnnum #returns your hourly pay (e.g. $18) times your hours per week (e.g. 25) times the number of weeks you work in a year (e.g. 48). Example salary: 18 * 25 * 48 = $21,600/yr.


func commitCrime(crime : String, severity : int, time): ##Commits crime.
	crimes.append(crime)
	crimesSeverity.append(severity)
	intellectAtTimeOfCrime.append(intellect)
	crimeTime.append(time)
	XPQueued += roundi(float(severity) / 2)

func crimeTimeCalculator(): ##Calculates how much time you need to serve for your crimes. Returns either a number in years or "Life" for a life sentence.
	var totalSentence = 0
	for i in crimeTime.size():
		if crimeTime[i] is int && totalSentence is int: #if it's not a life sentence yet and this crime doesn't warrant a life sentence
			totalSentence += crimeTime[i]
		elif str(crimeTime[i]) == "Life" && str(totalSentence) != "Life": #if it's not a life sentence yet but the crime being checked does warrant a life sentence
			totalSentence = "Life"
		#otherwise, you already have a life sentence, and there's no need to add to it
	return totalSentence

func prisonPreparer(sentenceLength): ##Does everything you need to prepare the player for prison, but you still have to actually be sent there manually.
	prisonSentence = sentenceLength
	XPQueued += roundi(float(sumCalculator(crimesSeverity)) / 4) #extra XP, but not as much as if you got away with it
	for i in crimes.size():
		criminalRecord.append(crimes[i])
		criminalRecordSeverity.append(crimesSeverity[i])
	if fullTimeJob != "":
		revent.append("full-time-fired-imprisonment")
	if partTimeJob != "":
		revent.append("part-time-fired-imprisonment")
	if schoolLevel != -1 && schoolLevel != 0: #if you are in school or university
		revent.append("school-kicked-out-imprisonment")


func averageFinder(array): ##Finds the mean average of all integer elements in any array.
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
func lifeSerialiser(): ##Serialises every life-specific variable we need to save into a dictionary and then returns it.
	var collinsDictionary = {
		#engine
		"versionNumber" : versionNumber,
		"revent" : revent,
		"RAUE" : RAUE,
		"eventMemory" : eventMemory,
		"IDClicked" : IDClicked,
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
		"jobOpenings" : jobOpenings,
		"partTimeJobOpenings" : partTimeJobOpenings,
		"allJobSalaries" : allJobSalaries,
		"allPartTimeJobSalaries" : allPartTimeJobSalaries,
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
		"licences" : licences,
		"certificates" : certificates,
		"failedCertificates" : failedCertificates,
		"incomeTax" : incomeTax,
		"fullTimeJob" : fullTimeJob,
		"fullTimeSalary" : fullTimeSalary,
		"partTimeJob" : partTimeJob,
		"partTimeRate" : partTimeRate,
		"partTimeHours" : partTimeHours,
		"workExperience" : workExperience,
		"schoolPerformance" : schoolPerformance,
		"partTimePerformance" : partTimePerformance,
		"fullTimePerformance" : fullTimePerformance,
		"fullTimeEffectJoy" : fullTimeEffectJoy,
		"fullTimeEffectHealth" : fullTimeEffectHealth,
		"fullTimeEffectIntellect" : fullTimeEffectIntellect,
		"fullTimeEffectLooks" : fullTimeEffectLooks,
		"fullTimeEffectEvality" : fullTimeEffectEvality,
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
		"deadPersonCause" : deadPersonCause,
		"deadPersonCategories" : deadPersonCategories,
		"deadPersonRecency" : deadPersonRecency,
		#misc
		"eventPersonFirstName" : eventPersonFirstName,
		"eventPersonLastName" : eventPersonLastName,
		"eventPersonAge" : eventPersonAge,
		"eventPersonSex" : eventPersonSex,
		"degreePicked" : degreePicked,
		"degreePickedCost" : degreePickedCost,
		"degreePickedLoanDuration" : degreePickedLoanDuration,
		"degreePickedLoanInterest" : degreePickedLoanInterest,
		#keeping track
		"joyOverTime" : joyOverTime,
		"healthOverTime" : healthOverTime,
		"intellectOverTime" : intellectOverTime,
		"looksOverTime" : looksOverTime,
		"XPQueued" : XPQueued,
		"history" : history,
	}
	return collinsDictionary

func gameSerialiser(): ##Serialises every NON-life-specific variable we need to save into a dictionary and then returns it.
	var cambridgeDictionary = {
		"versionNumber" : versionNumber,
		"windowSize" : windowSize,
		"currentLife" : currentLife,
		"XP" : XP,
		"level" : level,
		"XPRequired" : XPRequired,
		"developerModePassword" : developerModePassword,
		"keyboardShortcutsEnabled" : keyboardShortcutsEnabled,
		"dangerousKeyboardShortcuts" : dangerousKeyboardShortcuts,
		"bigMailto" : bigMailto,
	}
	return cambridgeDictionary

func getSaveLifeFileName(): ##Will return a unqiue file name for a life save, e.g. "Marsden-Gord-9".
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

func directoryGetter(): ##Gets path to life save files.
	getSaveLifeFileName() #makes sure path exists
	return "user://spycarsinc/bls/lives/" #returns path

func versionCompare(minimumVersion : Array[int], saveVersion : Array[int]): ##Compares any two version numbers (used when loading save files) and returns either true or false; true if the saveVersion meets the minimumVersion needed and false if it does not.
	var minVerInt = 0
	minVerInt += minimumVersion[0] * 100000000
	minVerInt += minimumVersion[1] * 100000
	minVerInt += minimumVersion[2] * 100
	var saveVerInt = 0
	saveVerInt += saveVersion[0] * 100000000
	saveVerInt += saveVersion[1] * 100000
	saveVerInt += saveVersion[1] * 100
	if saveVerInt < minVerInt: #if the save version number is lower than the minimum version number
		return false
	else:
		return true

func saveGame(): ##Does the actual saving.
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
	var gameSavePath = "user://spycarsinc/bls/game.bls" #this save stores all of the non-life-specific stuff that does persist between lives (achievements, XP and levels, DNA, etc...)
	if customGameSaveDir != "": #if you're saving your game to a custom directory
		var antiOverwriteAppendix = 0 #this number is appended to the end of the file name. This makes it unique, avoiding overwrites of saves you wanted to keep.
		gameSavePath = customGameSaveDir + "/bls-game-"
		while FileAccess.file_exists(gameSavePath + str(antiOverwriteAppendix) + ".bls"): #if we're about to write to a file that already exists
			antiOverwriteAppendix += 1 #add to the appendix number to try and make it unique, then repeat this check again
		gameSavePath += str(antiOverwriteAppendix) + ".bls" #finalises the name once the above checks have passed and the name is unique
		customGameSaveDir = "" #reset, that's all we need the custom directory for
	var gameSaveFile = FileAccess.open(gameSavePath, FileAccess.WRITE)
	#and now do the rest
	gameSaveFile.store_var(gameSerialiser()) #overwrites the game save file with cambridgeDictionary from the gameSerialiser() function above.
	gameSaveFile.close() #closes file and saves changes

func loadGame(base64game = ""): ##Does the actual GAME loading.
	var gameSavePath = "user://spycarsinc/bls/game.bls"
	var gameSaveFile
	var dictionary
	if base64game == "": #if we're loading from a file and not clipboard (i.e. a base64 string) (see importProgressFromClipboard.gd)
		if FileAccess.file_exists("user://spycarsinc/bls/game.bls") == true: #if the game save file exists, continue and load
			if customGameImportDir != "": #if you have a custom file you would like to import from (see again importExportSaveFiles.gd)
				gameSavePath = customGameImportDir
				customGameImportDir = "" #we no longer need this
			gameSaveFile = FileAccess.open(gameSavePath, FileAccess.READ) #opens file to read
			dictionary = gameSaveFile.get_var()
		else: #file does not exist
			print("no game save file, will create a brand new one...")
			if not DirAccess.dir_exists_absolute("user://spycarsinc/bls/"): #if the folder we need does not exist, create it
				DirAccess.make_dir_recursive_absolute("user://spycarsinc/bls/")
				gameSaveFile = FileAccess.open(gameSavePath, FileAccess.READ) #opens file to read
	else: #if we're loading from base64
		dictionary = JSON.parse_string(Marshalls.base64_to_utf8(base64game)) #creates a dictionary of the de-encoded base64 save file to use below:
	if gameSaveFile != null || base64game != "": #if the file has data to load (WON'T be true upon first ever startup, which is good, we don't want to load from a file that has N O T H I N G) OR we're loading from base64
		windowSize = intIser(dictionary["windowSize"])
		currentLife = dictionary["currentLife"]
		XP = dictionary["XP"]
		level = dictionary["level"]
		XPRequired = dictionary["XPRequired"]
		developerModePassword = dictionary["developerModePassword"]
		keyboardShortcutsEnabled = dictionary["keyboardShortcutsEnabled"]
		dangerousKeyboardShortcuts = dictionary["dangerousKeyboardShortcuts"]
		bigMailto = dictionary["bigMailto"]
		if gameSaveFile != null: #if we're loading from a file, close it
			gameSaveFile.close() #closes file so it doesn't do anything weird
		print("hoorah, game load successful")
		print(currentLife)
		return #cease function function

func loadLife(takeHome = true, base64life = ""): ##Does the actual LIFE loading from a save file (the one at currentLife if it isn't blank), and takes you to the game menu unless takeHome specified as false.
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
	var _lifeVersion = intIser(dictionary["versionNumber"].split(".")) #keep an integer array version of this game's verison number; use this to check if you're loading a life from a previous update (one that won't have the variables you're trying to load) by seeing if all indexes are lower in value than the corresponding indexes in the version you're checking using versionCompare. For example, to check if version 2.5.6 is a lower update than version 3.1.4, call versionCompare([2, 5, 6], [3, 1, 4]). versionCompare will return true if the first array meets the minimum update requirements (the second array) and false if it does not.
	revent = dictionary["revent"]
	RAUE = dictionary["RAUE"]
	eventMemory = dictionary["eventMemory"]
	IDClicked = dictionary["IDClicked"]
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
	jobOpenings = dictionary["jobOpenings"]
	partTimeJobOpenings = dictionary["partTimeJobOpenings"]
	allJobSalaries = intIser(dictionary["allJobSalaries"])
	jobSavers("load", "full")
	allPartTimeJobSalaries = intIser(dictionary["allPartTimeJobSalaries"])
	jobSavers("load", "part")
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
	licences = dictionary["licences"]
	certificates = dictionary["certificates"]
	failedCertificates = dictionary["failedCertificates"]
	incomeTax = dictionary["incomeTax"]
	fullTimeJob = dictionary["fullTimeJob"]
	fullTimeSalary = dictionary["fullTimeSalary"]
	partTimeJob = dictionary["partTimeJob"]
	partTimeRate = dictionary["partTimeRate"]
	partTimeHours = dictionary["partTimeHours"]
	workExperience = dictionary["workExperience"]
	schoolPerformance = dictionary["schoolPerformance"]
	partTimePerformance = dictionary["partTimePerformance"]
	fullTimePerformance = dictionary["fullTimePerformance"]
	fullTimeEffectJoy = dictionary["fullTimeEffectJoy"]
	fullTimeEffectHealth = dictionary["fullTimeEffectHealth"]
	fullTimeEffectIntellect = dictionary["fullTimeEffectIntellect"]
	fullTimeEffectLooks = dictionary["fullTimeEffectLooks"]
	fullTimeEffectEvality = dictionary["fullTimeEffectEvality"]
	loans = intIser(dictionary["loans"])
	loanInitialValue = intIser(dictionary["loanInitialValue"])
	loanPaybackDuration = intIser(dictionary["loanPaybackDuration"])
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
	deadPersonCause = dictionary["deadPersonCause"]
	deadPersonCategories = dictionary["deadPersonCategories"]
	deadPersonRecency = dictionary["deadPersonRecency"]
	#misc
	eventPersonFirstName = dictionary["eventPersonFirstName"]
	eventPersonLastName = dictionary["eventPersonLastName"]
	eventPersonAge = dictionary["eventPersonAge"]
	eventPersonSex = dictionary["eventPersonSex"]
	degreePicked = dictionary["degreePicked"]
	degreePickedCost = dictionary["degreePickedCost"]
	degreePickedLoanDuration = dictionary["degreePickedLoanDuration"]
	degreePickedLoanInterest = dictionary["degreePickedLoanInterest"]
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


func loadList(path, splitter): ##Loads list of anything from a seperate file :) used mainly for names. Thanks to GrayyGray for using this method originally in a fork.
	return FileAccess.get_file_as_string(path).split(splitter) #items in the list are split up by commas followed by spaces
#lists end in a comma followed by a space so any useless data after it (i.e. a new line) is included as the last element, which is popped (removed) when this script is loaded. must be strictly typed as arrays because otherwise godot automatically makes the name arrays and other string arrays into "packed string arrays", which don't let you remove elements as far as I know, but are more memory-efficient than regular arrays. Trust me, I would use those if I could.

#global arrays that are loaded from external files
var tips : Array = loadList("res://data/tips.txt", " | ") ##tips to be displayed on the screen during loading :) - items in THIS list are seperated by " | "
#names
var mFirstNames : Array = loadList("res://data/names/mFirstNames.txt", ", ") ##loads list of masculine first names
var fFirstNames : Array = loadList("res://data/names/fFirstNames.txt", ", ") ##feminine first names
var uFirstNames : Array = loadList("res://data/names/uFirstNames.txt", ", ") ##unisex first names
var lastNames : Array = loadList("res://data/names/lastNames.txt", ", ") ##dude just look at the variable name
var rareFirstNames : Array = loadList("res://data/names/rareFirstNames.txt", ", ") ##Only generated in pairs of first name and last name. Regular names roll once for a first name and again to pick a last name, whereas rare names only roll once and pick the corresponding first and last name. So picking "Rob" as a rare first name cannot result in the name "Rob Salad", it will always result in "Rob Ery" as they are both at the same index. This is to make seperating first and last names easier, but also preserve the rare name as originally intended.
var rareLastNames : Array = loadList("res://data/names/rareLastNames.txt", ", ") ##Paired with rareFirstNames. Marl and ™ have only a first name. This will result in some weird behaviour, such as the player being called "Mr./Mrs.[blank]", but that is a sarcrifice I am willing to make.


func _ready() -> void: #when this is loaded for the first time (once when the game starts and never again while it's still running)
	#removes the last element of all IMPORTED arrays (from a txt file in res://data/), which SHOULD be occupied by dead space and no actual data
	tips.pop_back()
	mFirstNames.pop_back()
	fFirstNames.pop_back()
	uFirstNames.pop_back()
	lastNames.pop_back()
	rareFirstNames.pop_back()
	rareLastNames.pop_back()


#keyboard shortcuts - disabled by defualt and locked under dangerous keyboard shortcuts because they made cheesing the game, namely events, way too easy.
func _unhandled_input(inputMade: InputEvent) -> void: #if you make an input
	if keyboardShortcutsEnabled == false || dangerousKeyboardShortcuts == false: #if shortcuts or dangerous shortcuts are disabled, do not proceed
		return
	if inputMade.is_action_pressed("shortcut_to_gamemenu"): #ctrl + shift + h (go to homepage)
		if currentLife != "": #if you have a life to load
			loadLife()
		else:
			print("no life to load")
	elif inputMade.is_action_pressed("shortcut_to_save_import_export"): #ctrl + shift + s (go to import/export save files menu) - put this before crtl + s because this also meets the conditions of that; if this is not placed first, the shift will be ignored and you will be taken to browse life save files
		get_tree().change_scene_to_file("res://pages/import_export_save_files.tscn")
	elif inputMade.is_action_pressed("shortcut_to_save_files_browse"): #ctrl + s (browse life save files)
		get_tree().change_scene_to_file("res://pages/life_save_files.tscn")
	elif inputMade.is_action_pressed("shortcut_to_developer_mode"): #ctrl + shift + d (go to developer mode)
		if currentLife != "": #if you have a life to edit in developer mode
			if developerModePassword == "opensesame": #if you have the correct password saved
				get_tree().change_scene_to_file("res://pages/developer_mode.tscn")
			else: #if you do not have the correct password saved
				get_tree().change_scene_to_file("res://pages/developer_mode_confirmation.tscn")
		else:
			print("no life to load")
	elif inputMade.is_action_pressed("shortcut_to_settings"): #ctrl + shift + p (go to settings - p stands for preferences as s is taken by save files)
		get_tree().change_scene_to_file("res://pages/settings.tscn")
	elif inputMade.is_action_pressed("shortcut_to_main_menu"): #ctrl + shit + m (go to main menu)
		get_tree().change_scene_to_file("res://pages/main_menu.tscn")
