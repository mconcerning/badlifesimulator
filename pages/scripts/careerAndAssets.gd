extends Node2D #author(s): Ethan Scott


@onready var scrollContainer = $scrollContainer/vBoxContainer
const button = preload("res://objects/button_default.tscn")
const subheading = preload("res://objects/subheading.tscn")
const body = preload("res://objects/body.tscn")
const blankBox = preload("res://objects/blank_box.tscn")


func lineBreak(): ##Creates a blank body paragraph in the scroll container to function as a line break, or section seperation.
	var lnBreak = blankBox.instantiate() #uses body text instead of a subheading be
	lnBreak.custom_minimum_size.y = 1
	scrollContainer.add_child(lnBreak)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#button and heading generation
	if global.schoolLevel == 1 || global.schoolLevel == 2 || global.schoolLevel == 3: #if you're in school
		var schoolHeading = subheading.instantiate()
		match global.schoolLevel:
			1:
				schoolHeading.text = "Primary school"
			2:
				schoolHeading.text = "High school"
			3:
				schoolHeading.text = "University"
		#subheading colour change for differentiation (currently disabled bc it looks like shit)
		#var lSet = schoolHeading.label_settings.duplicate() #duplicates the label settings (makes them unique) so changes to it don't affect any other labels
		#lSet.font_color = Color.from_rgba8(0, 0, 255, 255)
		#schoolHeading.label_settings = lSet
		scrollContainer.add_child(schoolHeading)
		var school = button.instantiate()
		school.text = global.schoolName
		school.pressed.connect(schoolClicked.bind())
		scrollContainer.add_child(school)
		lineBreak()
	elif global.schoolLevel == 0: #if you've graduated
		var degreeHeading = subheading.instantiate()
		degreeHeading.text = "Not in school"
		scrollContainer.add_child(degreeHeading)
		var enroll = button.instantiate()
		enroll.text = "Enroll in University"
		scrollContainer.add_child(enroll)
		lineBreak()
	if global.fullTimeJob != "":
		var fullTimeJobHeading = subheading.instantiate()
		fullTimeJobHeading.text = "Full-time job"
		scrollContainer.add_child(fullTimeJobHeading)
		var fullTimeJob = button.instantiate()
		fullTimeJob.text = global.fullTimeJob
		scrollContainer.add_child(fullTimeJob)
		lineBreak()
	elif global.schoolLevel == 0: #if you don't have a full-time job, but you're also not in school
		var searchHeading = subheading.instantiate()
		searchHeading.text = "Unemployed"
		scrollContainer.add_child(searchHeading)
		var search = button.instantiate()
		search.text = "Search for a job"
		scrollContainer.add_child(search)
		lineBreak()
	if global.partTimeJob != "":
		var partTimeJobHeading = subheading.instantiate()
		partTimeJobHeading.text = "Part-time job"
		scrollContainer.add_child(partTimeJobHeading)
		var partTimeJob = button.instantiate()
		partTimeJob.text = global.partTimeJob
		scrollContainer.add_child(partTimeJob)
		lineBreak()
	elif global.age >= 15: #if you don't have a part-time job, but you're 15 or older
		var searchHeading = subheading.instantiate()
		searchHeading.text = "No part-time job"
		scrollContainer.add_child(searchHeading)
		var search = button.instantiate()
		search.text = "Look for a gig"
		scrollContainer.add_child(search)
		lineBreak()


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://pages/game_menu.tscn")


func schoolClicked():
	get_tree().change_scene_to_file("res://pages/school.tscn")
