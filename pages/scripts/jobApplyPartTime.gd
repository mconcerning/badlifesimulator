extends Node2D #author(s): Ethan Scott


@onready var applyButton = $scrollContainer/vBoxContainer/apply


func qualificationChecker(): ##Checks if you're qualified to apply for this job (i.e. you meet the minimum requirements).
	applyButton.disabled = true
	match global.partTimeJobOpenings[global.IDClicked][0]:
		"Lifeguard":
			if global.age >= 18 && global.health >= 75:
				applyButton.disabled = false


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://pages/job_search_part_time.tscn")

func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://pages/game_menu.tscn")


func applyForJob():
	var applicationRecord = "applied-for-part-time-" + global.partTimeJobOpenings[global.IDClicked][0]
	if global.history.has(applicationRecord): #if you've already tried to apply for this job this year
		global.revent.append("part-time-job-applied-already")
	elif global.history.has(global.partTimeJobOpenings[global.IDClicked][0] + "-fired-part-time") || global.history.has(global.partTimeJobOpenings[global.IDClicked][0] + "-quit-part-time"): #if you've already had this job this year but you've been fired or you've quit
		global.revent.append("part-time-job-apply-fired-quit-already")
	else:
		if randi_range(1, 4) != 1: #if get accepted; for this you need to be qualified (1 in 4 chance of being denied even if you are) - you have to be qualified to be able to even press the apply button, so no need to check eligibility here
			#gives you the job
			global.partTimeJob = global.partTimeJobOpenings[global.IDClicked][0]
			global.partTimeRate = global.partTimeJobOpenings[global.IDClicked][1]
			global.partTimeHours = global.partTimeJobOpenings[global.IDClicked][2]
			global.partTimePerformance = randi_range(45, 60)
			global.revent.append("part-time-job-applied-accepted")
		else: #if you're unlucky and get denied for the position even though you're qualified
			global.revent.append("part-time-job-applied-rejected")
		global.history.append("applied-for-" + global.partTimeJobOpenings[global.IDClicked][0])
	get_tree().change_scene_to_file("res://pages/event.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$jobName.text = global.partTimeJobOpenings[global.IDClicked][0]
	$details.text = "Rate: $" + global.commaiser(global.partTimeJobOpenings[global.IDClicked][1]) + "/hr | Hours: " + global.commaiser(global.partTimeJobOpenings[global.IDClicked][2]) + "/wk\nPay per year: $" + global.commaiser(global.partTimeJobOpenings[global.IDClicked][1] * global.partTimeJobOpenings[global.IDClicked][2] * global.partTimeWorkWeeksPerAnnum) + "\nRequires: " + global.partTimeJobOpenings[global.IDClicked][3] #salary = rate * hours * weeks per hour
	qualificationChecker()


func _on_apply_pressed() -> void:
	applyForJob()
