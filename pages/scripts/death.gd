extends Node2D #author(s): Ethan Scott


var timerRuns = 0 #how many times has the 100ms timer timed out?
var avgJoy = averageFinder(global.joyOverTime)
var avgHealth = averageFinder(global.healthOverTime)
var avgIntellect = averageFinder(global.intellectOverTime)
var avgLooks = averageFinder(global.looksOverTime)
var XPThatWasQueued = 0 #since XPQueued is cleared before you can see it and moving its clearing until after you're shown it would cause issues with saving and therefore cheesing death, it is stored here temporarily and holds no bearing on how much XP you actually earn
var didLevelUp = false


func averageFinder(array): #finds the average value of all elements in an array (note: only works if all elements are numerals, because of maths)
	var average = 0
	if array.size() > 0: #if the array is not empty
		for i in array.size(): #runs through every element in the array
			average += array[i] #adds the value of the element at i to the average
		average = round(average / array.size()) #divides the average by the size of the array (i.e. turns it into the mean) and rounds the result
	else: #if the array is empty
		average = "nothing in the array :("
	return average


func _on_100ms_timeout() -> void: #every 0.1s
	if timerRuns == 0:
		$statsTop.text += global.causeOfDeath
	elif timerRuns == 1:
		$statsLeft.text += "Age at death: " + str(global.age)
	elif timerRuns == 2: #first left-justified stat
		$statsLeft.text += "\n\nAverage Joy: " + str(averageFinder(global.joyOverTime))
	elif timerRuns == 3:
		$statsLeft.text += "\nJoy at death: " + str(global.joy)
	elif timerRuns == 4:
		$statsLeft.text += "\n\nAverage Health: " + str(averageFinder(global.healthOverTime))
	elif timerRuns == 5:
		$statsLeft.text += "\nHealth at death: " + str(global.health)
	elif timerRuns == 6:
		$statsLeft.text += "\n\nAverage Intellect: " + str(averageFinder(global.intellectOverTime))
	elif timerRuns == 7:
		$statsLeft.text += "\nIntellect at death: " + str(global.intellect)
	elif timerRuns == 8:
		$statsLeft.text += "\n\nAverage Looks: " + str(averageFinder(global.looksOverTime))
	elif timerRuns == 9:
		$statsLeft.text += "\nLooks at death: " + str(global.looks)
	elif timerRuns == 10:
		$statsLeft.text += "\n\nXP: " + str(global.XP)
	elif timerRuns == 11:
		$statsLeft.text += "\nXP earned: " + str(XPThatWasQueued)
	elif timerRuns == 12:
		$statsRight.text += "Level " + str(global.level)
	elif timerRuns == 13: #first right-justified stat
		$statsRight.text += "\n\nYou need " + str(global.XPRequired - global.XP) + " more XP to level up"
	elif timerRuns == 14:
		if didLevelUp == true: #if you levelled up
			$levelUp.text = "Level up"
	elif timerRuns == 15:
		$home.position.x = 402 #puts the home button on-screen
		$"100ms".queue_free() #this is the last thing the timer has to take care of, and so it can safely be combusted in the name of (ever so slightly) improving performance
		$backgroundRed.queue_free() #also deletes the background, because even though it would be invisible at this point, I think it interferes with you interacting with anything on-screen (i.e. the button) because it's drawn on top
	timerRuns += 1


func _on_2s_timeout() -> void: #first 2s; i.e. runs after animation is finished playing
	$"100ms".start() #starts playing the stats reveal animation. $100ms doesn't work here for some reason (??)


func _on_home_pressed() -> void:
	get_tree().change_scene_to_file("res://pages/main_menu.tscn")


#when you die
func _ready() -> void:
	if global.firstName == "Immortal" && global.lastName == "Guy":
		get_tree().change_scene_to_file("res://pages/game_menu.tscn")
		return
	if FileAccess.file_exists("user://spycarsinc/bls/lives/" + global.currentLife + ".bls") == true: #if a save file for this life exists
		DirAccess.remove_absolute("user://spycarsinc/bls/lives/" + global.currentLife + ".bls") #deletes the save file for this life
		print("successfully deleted save file for " + global.currentLife)
	global.currentLife = "" #no more currentLife
	#last-minute extra XP calculations
	global.XPQueued += global.age #gives you your age in XP
	var XPFromStats = 0
	XPFromStats += round(float(global.joy) / 2) #gives you half of all your main stats' values upon death in XP
	XPFromStats += round(float(global.health) / 2)
	XPFromStats += round(float(global.intellect) / 2)
	XPFromStats += round(float(global.looks) / 2)
	XPFromStats += round(averageFinder(global.joyOverTime) / 2) #gives half you all your average stats' values in XP upon death
	XPFromStats += round(averageFinder(global.healthOverTime) / 2)
	XPFromStats += round(averageFinder(global.intellectOverTime) / 2)
	XPFromStats += round(averageFinder(global.looksOverTime) / 2)
	XPFromStats = round(XPFromStats / 100 * global.age) #how old you are directly affects how much XP you earn from having high stats so you can't just farm XP by spawning a bunch of lives and immediately dying over and over again. Also, your stats aren't worth much in XP. That's by design to discourage overprioritising them during your life.
	global.XPQueued += round(float(global.money) / 1000) #gives you a 1000th of your money upon death in XP
	#the rest of everything
	global.XP += global.XPQueued #adds the XP you are owed to your XP
	XPThatWasQueued = global.XPQueued
	global.XPQueued = 0 #you are no longer owed XP
	while global.XP >= global.XPRequired: #while you have more XP than you need to level up
		global.XP -= global.XPRequired #deducts the XP required to level up from your XP
		global.level += 1 #levels up
		global.XPRequired += 500 #makes the next level up harder to reach
		didLevelUp = true
	global.saveGame()
