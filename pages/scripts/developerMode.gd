extends Node2D #author(s): Ethan Scott


func _ready() -> void:
	if global.RAUE == true:
		$scrollContainer/centerContainer/vBoxContainer/RAUECheck.frame = 1
	else: #if global.RAUE == false
		$scrollContainer/centerContainer/vBoxContainer/RAUECheck.frame = 0


func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://pages/new_game_confirmation.tscn") #go back


func _on_save_game_pressed() -> void:
	get_tree().change_scene_to_file("res://pages/save_game.tscn")


func _on_set_age_pressed() -> void:
	global.age = int($input.text)
	$confirmation.text = "Successfully set age!"
	print("set age to " + str(global.age))

func _on_set_joy_pressed() -> void:
	global.joy = int($input.text)
	$confirmation.text = "Successfully set joy!"
	print("set joy to " + str(global.joy))

func _on_set_health_pressed() -> void:
	global.health = int($input.text)
	$confirmation.text = "Successfully set health!"
	print("set health to " + str(global.health))

func _on_set_intellect_pressed() -> void:
	global.intellect = int($input.text)
	$confirmation.text = "Successfully set intellect!"
	print("set intellect to " + str(global.intellect))

func _on_set_looks_pressed() -> void:
	global.looks = int($input.text)
	$confirmation.text = "Successfully set looks!"
	print("set looks to " + str(global.looks))

func _on_raue_pressed() -> void:
	if global.RAUE == true:
		$scrollContainer/centerContainer/vBoxContainer/RAUECheck.frame = 0
		global.RAUE = false
		$confirmation.text = "Successfully set RAUE to false!"
	else: #if false
		$scrollContainer/centerContainer/vBoxContainer/RAUECheck.frame = 1
		global.RAUE = true
		$confirmation.text = "Successfully set RAUE to true!"
	print("set RAUE to " + str(global.RAUE))

func _on_set_evality_pressed() -> void:
	global.evality = int($input.text)
	$confirmation.text = "Successfully set evality!"
	print("set evality to " + str(global.evality))

func _on_die_pressed() -> void:
	global.causeOfDeath = "You died because you developed too hard"
	get_tree().change_scene_to_file("res://pages/death.tscn") #kills you

func _on_set_xp_pressed() -> void:
	global.XP = int($input.text)
	$confirmation.text = "Successfully set XP!"
	print("set XP to " + str(global.XP))

func _on_set_xp_required_pressed() -> void:
	global.XPRequired = int($input.text)
	$confirmation.text = "Successfully set XPRequired!"
	print("set XPRequired to " + str(global.XPRequired))

func _on_set_xp_queued_pressed() -> void:
	global.XPQueued = int($input.text)
	$confirmation.text = "Successfully set XPQueued!"
	print("set XPQueued to " + str(global.XPQueued))

func _on_set_level_pressed() -> void:
	global.level = int($input.text)
	$confirmation.text = "Successfully set level!"
	print("set level to " + str(global.level))

func _on_set_first_name_pressed() -> void:
	global.firstName = str($input.text)
	$confirmation.text = "Successfully set first name!"
	print("set first name to " + str(global.firstName))

func _on_set_last_name_pressed() -> void:
	global.lastName = str($input.text)
	$confirmation.text = "Successfully set last name!"
	print("set last name to " + str(global.lastName))

func _on_set_family_types_pressed() -> void:
	global.familyTypes = Array($input.text.split(","))
	$confirmation.text = "Successfully set family types!"
	print("set family types to " + str(global.familyTypes))

func _on_set_family_ages_pressed() -> void:
	var strToInt = $input.text.split(",") #string to int (turns string into integers in conjunction with the following for loop)
	var intdStr = [] #int'd string
	for i in strToInt.size():
		intdStr.append(int(strToInt[i]))
	global.familyAges = intdStr
	$confirmation.text = "Successfully set family ages!"
	print("set family ages to " + str(global.familyAges))

func _on_set_family_sexes_pressed() -> void:
	global.familySexes = Array($input.text.split(","))
	$confirmation.text = "Successfully set family sexes!"
	print("set family sexes to " + str(global.familySexes))

func _on_set_family_first_names_pressed() -> void:
	global.familyFirstNames = Array($input.text.split(","))
	$confirmation.text = "Successfully set family first names!"
	print("set family first names to " + str(global.familyFirstNames))

func _on_set_family_last_names_pressed() -> void:
	global.familyLastNames = Array($input.text.split(","))
	$confirmation.text = "Successfully set family last names!"
	print("set family last names to " + str(global.familyLastNames))

func _on_set_family_relationships_pressed() -> void:
	var strToInt = $input.text.split(",")
	var intdStr = []
	for i in strToInt.size():
		intdStr.append(int(strToInt[i]))
	global.familyRelationships = intdStr
	$confirmation.text = "Successfully set family relationships!"
	print("set family relationships to " + str(global.familyRelationships))

func _on_set_misc_types_pressed() -> void:
	global.miscTypes = Array($input.text.split(","))
	$confirmation.text = "Successfully set misc types!"
	print("set misc types to " + str(global.miscTypes))

func _on_set_misc_ages_pressed() -> void:
	var strToInt = $input.text.split(",")
	var intdStr = []
	for i in strToInt.size():
		intdStr.append(int(strToInt[i]))
	global.miscAges = intdStr
	$confirmation.text = "Successfully set misc ages!"
	print("set misc ages to " + str(global.miscAges))

func _on_set_misc_sexes_pressed() -> void:
	global.miscSexes = Array($input.text.split(","))
	$confirmation.text = "Successfully set misc sexes!"
	print("set misc sexes to " + str(global.miscSexes))

func _on_set_misc_first_names_pressed() -> void:
	global.miscFirstNames = Array($input.text.split(","))
	$confirmation.text = "Successfully set misc first names!"
	print("set misc first names to " + str(global.miscFirstNames))

func _on_set_misc_last_names_pressed() -> void:
	global.miscLastNames = Array($input.text.split(","))
	$confirmation.text = "Successfully set misc last names!"
	print("set misc last names to " + str(global.miscLastNames))

func _on_set_misc_relationships_pressed() -> void:
	var strToInt = $input.text.split(",")
	var intdStr = []
	for i in strToInt.size():
		intdStr.append(int(strToInt[i]))
	global.miscRelationships = intdStr
	$confirmation.text = "Successfully set misc relationships!"
	print("set misc relationships to " + str(global.miscRelationships))
