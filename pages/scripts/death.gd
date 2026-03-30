extends Node2D #author(s): Ethan Scott


var timerRuns = 0 #how many times has the 100ms timer timed out?
var avgJoy = averageFinder(global.joyOverTime)
var avgHealth = averageFinder(global.healthOverTime)
var avgIntellect = averageFinder(global.intellectOverTime)
var avgLooks = averageFinder(global.looksOverTime)
var XPThatWasQueued = 0 #since XPQueued is cleared before you can see it and moving its clearing until after you're shown it would cause issues with saving and therefore cheesing death, it is stored here temporarily and holds no bearing on how much XP you actually earn


func averageFinder(array): #finds the average value of all elements in an array (note: only works if all elements are numerals, because of maths)
	var average = 0
	if array.size() > 0: #if the array is not empty
		for i in array.size(): #runs through every element in the array
			average += array[i] #adds the value of the element at i to the average
		average = str(round(average / array.size())) #divides the average by the size of the array (i.e. turns it into the mean) and rounds the result
	else: #if the array is empty
		average = "nothing in the array :("
	return average


func _on_100ms_timeout() -> void: #every 0.1s
	if timerRuns == 0:
		$stats.text += global.causeOfDeath
	elif timerRuns == 1:
		$stats.text += "\n\nAge at death: " + str(global.age)
	elif timerRuns == 2:
		$stats.text += "\n\nAverage Joy: " + averageFinder(global.joyOverTime)
	elif timerRuns == 3:
		$stats.text += "\nJoy at death: " + str(global.joy)
	elif timerRuns == 4:
		$stats.text += "\n\nAverage Health: " + averageFinder(global.healthOverTime)
	elif timerRuns == 5:
		$stats.text += "\nHealth at death: " + str(global.health)
	elif timerRuns == 6:
		$stats.text += "\n\nAverage Intellect: " + averageFinder(global.intellectOverTime)
	elif timerRuns == 7:
		$stats.text += "\nIntellect at death: " + str(global.intellect)
	elif timerRuns == 8:
		$stats.text += "\n\nAverage Looks: " + averageFinder(global.looksOverTime)
	elif timerRuns == 9:
		$stats.text += "\nLooks at death: " + str(global.looks)
	elif timerRuns == 10:
		$stats.text += "\n\nXP earned: " + str(XPThatWasQueued)
	elif timerRuns == 11:
		$stats.text += "\nLevel " + str(global.level)
	elif timerRuns == 12:
		$stats.text += "\nYou need " + str(global.XPRequired - global.XP) + " more XP to level up"
	timerRuns += 1


func _on_2s_timeout() -> void: #first 2s; i.e. runs after animation is finished playing
	get_node("100ms").start() #starts playing the stats reveal animation. $100ms doesn't work here for some reason (??)


#when you die
func _ready() -> void:
	if FileAccess.file_exists("user://spycarsinc/bls/lives/" + global.currentLife + ".bls") == true: #if a save file for this life exists
		DirAccess.remove_absolute("user://spycarsinc/bls/lives/" + global.currentLife + ".bls") #deletes the save file for this life
		print("successfully deleted save file for " + global.currentLife)
	global.currentLife = "" #no more currentLife
	global.XP += global.XPQueued #adds the XP you are owed to your XP
	XPThatWasQueued = global.XPQueued
	global.XPQueued = 0 #you are no longer owed XP
	while global.XP >= global.XPRequired: #while you have more XP than you need to level up
		global.XP -= global.XPRequired #deducts the XP required to level up from your XP
		global.level += 1 #levels up
		global.XPRequired += 500 #makes the next level up harder to reach
	global.saveGame()
