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
	var family = [] #filled with indexes of family members
	var misc = [] #filled with indexes of non-family relationships
	for i in global.personTypes.size(): #runs through everyone you know
		if global.personTypes[i] == "Mother" || global.personTypes[i] == "Father" || global.personTypes[i] == "Brother" || global.personTypes[i] == "Sister" || global.personTypes[i] == "Grandmother" || global.personTypes[i] == "Grandfather" ||global.personTypes[i] == "Aunt" || global.personTypes[i] == "Uncle" || global.personTypes[i] == "Cousin": #if the person at index i is a family member
			family.append(i) #adds their index to the family array
		else: #if the person at index i is NOT a family member
			misc.append(i)
	for i in family.size(): #runs through all family members
		#button
		var buttonInstance = button.instantiate() #creates a button for the family member at index family[i]
		buttonInstance.text = global.personFirstNames[family[i]] + " " + global.personLastNames[family[i]] #puts their name on the button
		$scrollContainer/centerContainer/vBoxContainer.add_child(buttonInstance) #places the button in the scene
		buttonInstance.pressed.connect(personClicked.bind(family[i], "family"))
		#label below
		var labelInstance = labelBelowLabel.instantiate() #creates the label for the family member at index family[i]
		labelInstance.text = global.personTypes[family[i]] + " (" + global.personSexes[family[i]] + "), Age " + str(global.personAges[family[i]]) + ", Relationship: " + str(global.personRelationships[family[i]]) + "\n"
		if labelInstance.get_minimum_size().x >= 1000:
			labelInstance.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
			labelInstance.size.x = 900
		$scrollContainer/centerContainer/vBoxContainer.add_child(labelInstance)
	subheadingInstance = sectionSeperators.instantiate()
	subheadingInstance.text = "Other"
	$scrollContainer/centerContainer/vBoxContainer.add_child(subheadingInstance)
	for i in misc.size(): #runs through any other people you know
		#button
		var buttonInstance = button.instantiate() #creates a button for the person at index misc[i]
		buttonInstance.text = global.personFirstNames[misc[i]] + " " + global.personLastNames[misc[i]] #puts their name on the button
		$scrollContainer/centerContainer/vBoxContainer.add_child(buttonInstance) #places the button in the scene
		buttonInstance.pressed.connect(personClicked.bind(misc[i], "type"))
		#label below
		var labelInstance = labelBelowLabel.instantiate() #creates the label for the misc person at index misc[i]
		labelInstance.text = global.personTypes[misc[i]] + " (" + global.personSexes[misc[i]] + "), Age " + str(global.personAges[misc[i]]) + ", Relationship: " + str(global.personRelationships[misc[i]]) + "\n"
		if labelInstance.get_minimum_size().x >= 1000:
			labelInstance.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
			labelInstance.size.x = 900
		$scrollContainer/centerContainer/vBoxContainer.add_child(labelInstance)
	$scrollContainer/centerContainer/vBoxContainer/noOfRelationships.text = "You have " + str(global.personTypes.size()) + " family members\nYou know " + str(global.personTypes.size()) + " other people\nYou know " + str(global.personTypes.size() + global.personTypes.size()) + " people in total"


func personClicked(personID, relationshipType): #positive numbers are family; negative numbers are other
	print("clicked person " + str(personID))
	global.IDClicked = personID
	global.IDClickedType = relationshipType
	get_tree().change_scene_to_file("res://pages/relationship_selected.tscn")
