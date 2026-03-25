extends Node2D #author(s): Ethan Scott


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame #waits until the frame is fully loaded. Without this, the screen flashes gray while on this scene
	global.age += 1 #the actual aging up
	print("age is now " + str(global.age))
	global.joy += randi_range(-8, 8) #randomly tweaks joy levels. can add anywhere from -8 (subtracts 8) to 8.
	global.health += randi_range(-8, 8)
	global.intellect += randi_range(-8, 8)
	global.looks += randi_range(-8, 8)
	for i in global.familyAges.size(): #runs through every family member and ages them up
		global.familyAges[i] += 1
	for i in global.miscAges.size(): #runs through every miscellanious person you know and ages them up
		global.miscAges[i] += 1
	if randi_range(1, 2) == 1 && global.RAUE == true: #if you're getting a random event (1 in 2 chance) and random events are enabled
		if global.age >= 2: #you must be 2 or over to get random age up events
			print("choosing random age up event...")
			if global.age <= 4: #if age is 4 or below
				global.revent.append("toddler-" + str(randi_range(0, 1))) #second number in the randi_range is the last ID for the event that exists
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
	if global.revent.size() > 0: #if there are random events slated to appear
		get_tree().change_scene_to_file("res://pages/event.tscn") #goes to the event page
	else: #if there aren't random events slated to appear
		get_tree().change_scene_to_file("res://pages/game_menu.tscn") #goes back to game menu
