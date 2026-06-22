extends Node2D #author(s): Ethan Scott


const scrl = "scrollContainer/vBoxContainer/" #prefix for the paths of the scroll container's children

@onready var applyButton = get_node(scrl + "apply")


var universityDegreesCount = global.degrees.size()


func qualificationChecker(): ##Checks if you're qualified for the job you've selected.
	applyButton.disabled = true
	match global.jobOpenings[global.IDClicked][0]:
		"Primary school teacher":
			if global.degrees.has("high-school") && global.intellect >= 70:
				applyButton.disabled = false
		"High school teacher":
			if universityDegreesCount >= 1:
				applyButton.disabled = false
		"University professor":
			if universityDegreesCount - 1 >= 1 && global.degrees.has("Education"): #if you have an education degree and at least one other degree
				applyButton.disabled = false
		"Public defender":
			if global.degrees.has("Law"):
				applyButton.disabled = false
		"Apprentice lawyer":
			if global.degrees.has("Law") && global.degreeProficiency[global.degrees.find("Law")] >= 65:
				applyButton.disabled = false
		"Laywer":
			if global.degrees.has("Law") && global.workExperience.count("Apprentice lawyer") >= 7: #if you have a law degree and the appropriate number of years experience
				applyButton.disabled = false
		"Fast food worker":
			if global.age >= 16: #if you're old enough to work here
				applyButton.disabled = false
		"Fast food manager":
			if global.workExperience.count("Fast food worker") >= 4 && global.intellect >= 60 && global.age >= 25:
				applyButton.disabled = false
		"Retail worker":
			if global.degrees.has("high-school"):
				applyButton.disabled = false
		"Apprentice logo designer":
			if global.degrees.has("Graphic design"):
				applyButton.disabled = false
		"Logo designer":
			if global.degrees.has("Graphic design") && global.workExperience.count("Apprentice logo designer") >= 6:
				applyButton.disabled = false
		"Jr. business consultant":
			if global.degrees.has("Business"):
				applyButton.disabled = false
		"Business consultant":
			if global.degrees.has("Business") && global.workExperience.count("Jr. business consultant") >= 8 && global.intellect >= 75:
				applyButton.disabled = false
		"Sanitation worker":
			if global.degrees.has("high-school"):
				applyButton.disabled = false
		"Salt technician":
			if global.degrees.has("high-school") && global.health >= 70:
				applyButton.disabled = false
		"Exorcist":
			if global.degrees.has("high-school"):
				applyButton.disabled = false
		"Plumber":
			if global.degrees.has("high-school") && global.certificates.has("Plumbery"):
				applyButton.disabled = false
		"Electrician":
			if global.degrees.has("Engineering") && global.certificates.has("Electrical engineering"):
				applyButton.disabled = false
		"Astrophysicist":
			if global.degrees.has("Physics"):
				applyButton.disabled = false
		"Cook":
			if global.workExperience.count("Kitchen hand") >= 3 && global.degrees.has("high-school"):
				applyButton.disabled = false
		"Head chef":
			if global.workExperience.count("Cook") >= 8:
				applyButton.disabled = false


func jobEffectsGiver():
	match global.jobOpenings[global.IDClicked][0]:
		"Primary school teacher":
			global.fullTimeEffectInitialiser() #sets all effects to 0
		"High school teacher":
			global.fullTimeEffectInitialiser(-2) #sets joy effect to -5
		"University professor":
			global.fullTimeEffectInitialiser(0, 0, 4) #sets intellect effect to +4
		"Public defender":
			global.fullTimeEffectInitialiser(-4, 0, 2) #sets joy effect to -4, intellect to +2
		"Apprentice lawyer":
			global.fullTimeEffectInitialiser(-4, 0, 3)
		"Laywer":
			global.fullTimeEffectInitialiser(-5, 0, 5)
		"Fast food worker":
			global.fullTimeEffectInitialiser(-3)
		"Fast food manager":
			global.fullTimeEffectInitialiser(-5)
		"Retail worker":
			global.fullTimeEffectInitialiser(-2)
		"Apprentice logo designer":
			global.fullTimeEffectInitialiser(3)
		"Logo designer":
			global.fullTimeEffectInitialiser(4)
		"Jr. business consultant":
			global.fullTimeEffectInitialiser(0, 0, 3)
		"Business consultant":
			global.fullTimeEffectInitialiser(0, 0, 5)
		"Sanitation worker":
			global.fullTimeEffectInitialiser(0, -7)
		"Salt technician":
			global.fullTimeEffectInitialiser(0, 0, 0, 3)
		"Exorcist":
			global.fullTimeEffectInitialiser(6, 0, 0, 0, 7) #secretly increases evality - your ass is so getting haunted doing this job
		"Plumber":
			global.fullTimeEffectInitialiser(0, -1)
		"Electrician":
			global.fullTimeEffectInitialiser()
		"Astrophysicist":
			global.fullTimeEffectInitialiser(0, 0, 2)
		"Cook":
			global.fullTimeEffectInitialiser(-1)
		"Head chef":
			global.fullTimeEffectInitialiser(-1, -1)


func applyForJob():
	var applicationRecord = "applied-for-" + global.jobOpenings[global.IDClicked][0]
	if global.history.has(applicationRecord): #if you've already tried to apply for this job this year
		global.revent.append("full-time-job-applied-already")
	elif global.history.has(global.jobOpenings[global.IDClicked][0] + "-fired") || global.history.has(global.jobOpenings[global.IDClicked][0] + "-quit"): #if you've already had this job this year but you've been fired or you've quit
		global.revent.append("full-time-job-apply-fired-quit-already")
	else:
		if randi_range(1, 4) != 1 || global.firstName == "Hire": #if get accepted; for this you need to be qualified (1 in 4 chance of being denied even if you are) - you have to be qualified to be able to even press the apply button, so no need to check eligibility here
			#gives you the job
			global.fullTimeJob = global.jobOpenings[global.IDClicked][0]
			global.fullTimeSalary = global.jobOpenings[global.IDClicked][1]
			global.fullTimePerformance = randi_range(45, 60)
			jobEffectsGiver()
			global.revent.append("full-time-job-applied-accepted")
		else: #if you're unlucky and get denied for the position even though you're qualified
			global.revent.append("full-time-job-applied-rejected")
		global.history.append("applied-for-" + global.jobOpenings[global.IDClicked][0])
	get_tree().change_scene_to_file("res://pages/event.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if global.degrees.has("primary-school"):
		universityDegreesCount -= 1
	if global.degrees.has("high-school"):
		universityDegreesCount -= 1
	$jobName.text = global.jobOpenings[global.IDClicked][0] #shows job name
	$details.text = "$" + global.commaiser(global.jobOpenings[global.IDClicked][1]) + "/yr\nRequires: " + global.jobOpenings[global.IDClicked][2] + "\nEffects: " + global.jobOpenings[global.IDClicked][3] #shows job salary, qualifications, etc.
	qualificationChecker()


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://pages/job_search_full_time.tscn")

func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://pages/game_menu.tscn")

func _on_apply_pressed() -> void:
	applyForJob()
