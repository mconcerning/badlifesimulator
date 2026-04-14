extends Node2D #author(s): Ethan Scott


const button = preload("res://objects/button_default.tscn")
const labelBelowLabel = preload("res://objects/body.tscn")
const sectionSeperators = preload("res://objects/subheading.tscn")


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://pages/game_menu.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#generates the buttons
	var subheadingInstance = sectionSeperators.instantiate()
	subheadingInstance.text = "Family"
	$scrollContainer/centerContainer/vBoxContainer.add_child(subheadingInstance)
	for i in global.familyTypes.size(): #runs through every family member
		#button
		var buttonInstance = button.instantiate() #creates a button for the family member at index i
		buttonInstance.text = global.familyFirstNames[i] + " " + global.familyLastNames[i] #puts their name on the button
		$scrollContainer/centerContainer/vBoxContainer.add_child(buttonInstance) #places the button in the scene
		buttonInstance.pressed.connect(personClicked.bind(i, "family"))
		#label below
		var labelInstance = labelBelowLabel.instantiate() #creates the label for the family member at index i
		labelInstance.text = global.familyTypes[i] + " (" + global.familySexes[i] + "), Age " + str(global.familyAges[i]) + ", Relationship: " + str(global.familyRelationships[i]) + "\n"
		if labelInstance.get_minimum_size().x >= 1000:
			labelInstance.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
			labelInstance.size.x = 900
		$scrollContainer/centerContainer/vBoxContainer.add_child(labelInstance)
	subheadingInstance = sectionSeperators.instantiate()
	subheadingInstance.text = "Other"
	$scrollContainer/centerContainer/vBoxContainer.add_child(subheadingInstance)
	for i in global.miscTypes.size(): #runs through any other people you know
		#button
		var buttonInstance = button.instantiate() #creates a button for the person at index i
		buttonInstance.text = global.miscFirstNames[i] + " " + global.miscLastNames[i] #puts their name on the button
		$scrollContainer/centerContainer/vBoxContainer.add_child(buttonInstance) #places the button in the scene
		buttonInstance.pressed.connect(personClicked.bind(i, "type"))
		#label below
		var labelInstance = labelBelowLabel.instantiate() #creates the label for the misc person at index i
		labelInstance.text = global.miscTypes[i] + " (" + global.miscSexes[i] + "), Age " + str(global.miscAges[i]) + ", Relationship: " + str(global.miscRelationships[i]) + "\n"
		if labelInstance.get_minimum_size().x >= 1000:
			labelInstance.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
			labelInstance.size.x = 900
		$scrollContainer/centerContainer/vBoxContainer.add_child(labelInstance)
	$scrollContainer/centerContainer/vBoxContainer/noOfRelationships.text = "You have " + str(global.familyTypes.size()) + " family members\nYou know " + str(global.miscTypes.size()) + " other people\nYou know " + str(global.familyTypes.size() + global.miscTypes.size()) + " people in total"


func personClicked(personID, relationshipType): #positive numbers are family; negative numbers are other
	print("clicked person " + str(personID))
	global.IDClicked = personID
	global.IDClickedType = relationshipType
	get_tree().change_scene_to_file("res://pages/relationship_selected.tscn")
