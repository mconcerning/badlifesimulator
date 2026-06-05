extends Node2D #author(s): Ethan Scott


func _ready() -> void:
	if global.RAUE == true:
		$scrollContainer/centerContainer/vBoxContainer/RAUE/RAUECheck.frame = 1
	else: #if global.RAUE == false
		$scrollContainer/centerContainer/vBoxContainer/RAUE/RAUECheck.frame = 0
	if global.developerModePassword == "AlwaysRequirePassword":
		$scrollContainer/centerContainer/vBoxContainer/DMRP/DMRPCheck.frame = 1
	else:
		$scrollContainer/centerContainer/vBoxContainer/DMRP/DMRPCheck.frame = 0


func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://pages/new_game_confirmation.tscn") #go back
	global.saveGame()


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
	if $input.text == "π":
		global.firstName = "Jesse"
		$input.text = str(3.14159265358979)
	global.intellect = int($input.text)
	$confirmation.text = "Successfully set intellect!"
	print("set intellect to " + str(global.intellect))

func _on_set_looks_pressed() -> void:
	global.looks = int($input.text)
	$confirmation.text = "Successfully set looks!"
	print("set looks to " + str(global.looks))

func _on_raue_pressed() -> void:
	if global.RAUE == true:
		$scrollContainer/centerContainer/vBoxContainer/RAUE/RAUECheck.frame = 0
		global.RAUE = false
		$confirmation.text = "Successfully set RAUE to false!"
	else: #if false
		$scrollContainer/centerContainer/vBoxContainer/RAUE/RAUECheck.frame = 1
		global.RAUE = true
		$confirmation.text = "Successfully set RAUE to true!"
	print("set RAUE to " + str(global.RAUE))

func _on_set_money_pressed() -> void:
	global.money = int($input.text)
	$confirmation.text = "Successfully set money!"
	print("set money to " + str(global.money))

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

func _on_set_school_level_pressed() -> void:
	global.schoolLevel = int($input.text)
	print("set school level to " + str(global.schoolLevel))
	if global.schoolLevel == 1 || global.schoolLevel == 2 || global.schoolLevel == 3:
		global.schoolName = "Institute of Developer Mode"
		global.schoolPerformance = global.intellect + randi_range(-6, 6)
		print("successfully enrolled in school")

func _on_trigger_event_pressed() -> void:
	global.revent.append(str($input.text))
	print("appended " + $input.text + " to global.revent")
	get_tree().change_scene_to_file("res://pages/event.tscn")

func _on_imprison_pressed() -> void:
	if global.crimes.size() == 0: #if you haven't really committed any crimes
		global.prisonSentence = 999
	print("imprisoning...")
	get_tree().change_scene_to_file("res://pages/game_menu.tscn")

func _on_set_crimes_pressed() -> void:
	global.crimes = Array($input.text.split(","))
	$confirmation.text = "Successfully set crimes!"
	print("set crimes")

func _on_set_crimes_severity_pressed() -> void:
	var crimesSeverityTemp = Array($input.text.split(","))
	for i in crimesSeverityTemp.size():
		crimesSeverityTemp[i] = int(crimesSeverityTemp[i])
	global.crimesSeverity = crimesSeverityTemp
	$confirmation.text = "Successfully set crime severities!"
	print("set crimes severity")

func _on_set_avg_intellect_crime_pressed() -> void:
	var avgIntellectTemp = Array($input.text.split(","))
	for i in avgIntellectTemp.size():
		avgIntellectTemp[i] = int(avgIntellectTemp[i])
	global.intellectAtTimeOfCrime = avgIntellectTemp
	$confirmation.text = "Successfully set intellectAtTimeOfCrime!"
	print("set intellect at time of crime")

func _on_set_crime_time_pressed() -> void:
	var timeTemp = Array($input.text.split(","))
	for i in timeTemp.size():
		if int(timeTemp[i]) != 0: #if it's not a weird string that can't be converted into a valid int, e.g. if this element is "Life"
			timeTemp[i] = int(timeTemp[i])
			global.crimeTime = timeTemp
		else:
			timeTemp = ["Life"]
			global.crimeTime = timeTemp
			$confirmation.text = "Successfully set crimeTime!"
			print("set crime time")
			return #stop- don't- stop-
	$confirmation.text = "Successfully set crimeTime!"
	print("set crime time")

func _on_loans_pressed() -> void:
	var loansTemp = Array($input.text.split(","))
	for i in loansTemp.size():
		loansTemp[i] = int(loansTemp[i])
	global.loans = loansTemp
	$confirmation.text = "Successfully set loans!"
	print("set loans")

func _on_loan_interest_pressed() -> void:
	var loanInterestTemp = Array($input.text.split(","))
	for i in loanInterestTemp.size():
		loanInterestTemp[i] = int(loanInterestTemp[i])
	global.loanInterest = loanInterestTemp
	$confirmation.text = "Successfully set loan interest!"
	print("set loan interest")

func _on_loan_payback_duration_pressed() -> void:
	var loanPaybackDurationTemp = Array($input.text.split(","))
	for i in loanPaybackDurationTemp.size():
		loanPaybackDurationTemp[i] = int(loanPaybackDurationTemp[i])
	global.loanPaybackDuration = loanPaybackDurationTemp
	$confirmation.text = "Successfully set loan payback duration!"
	print("set loan payback duration")

func _on_DM_password_pressed() -> void:
	if global.developerModePassword != "AlwaysRequirePassword":
		$scrollContainer/centerContainer/vBoxContainer/DMRP/DMRPCheck.frame = 1
		global.developerModePassword = "AlwaysRequirePassword"
		$confirmation.text = "Successfully set always req DM password to true!"
	else: #if you DON'T require password after clicking this
		$scrollContainer/centerContainer/vBoxContainer/DMRP/DMRPCheck.frame = 0
		global.developerModePassword = "opensesame"
		$confirmation.text = "Successfully set always req DM password to false!"
	print("set always require developer mode password to " + str(global.developerModePassword))

func _on_set_full_time_job_pressed() -> void:
	global.fullTimeJob = str($input.text)
	$confirmation.text = "Successfully set full time job!"
	print("set full time job to " + str(global.fullTimeJob))

func _on_set_full_time_job_salary_pressed() -> void:
	global.fullTimeSalary = int($input.text)
	$confirmation.text = "Successfully set full time salary!"
	print("set full time salary to " + str(global.fullTimeSalary))

func _on_set_full_time_job_performance_pressed() -> void:
	global.fullTimePerformance = int($input.text)
	$confirmation.text = "Successfully set full time performance!"
	print("set full time performance to " + str(global.fullTimePerformance))

func _on_set_part_time_job_pressed() -> void:
	global.partTimeJob = str($input.text)
	$confirmation.text = "Successfully set part time job!"
	print("set part time job to " + str(global.partTimeJob))

func _on_set_part_time_job_salary_pressed() -> void:
	global.partTimeSalary = int($input.text)
	$confirmation.text = "Successfully set part time salary!"
	print("set part time salary to " + str(global.partTimeSalary))

func _on_set_part_time_job_performance_pressed() -> void:
	global.partTimePerformance = int($input.text)
	$confirmation.text = "Successfully set part time performance!"
	print("set part time performance to " + str(global.partTimePerformance))
