extends Node2D #author(s): Ethan Scott


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://pages/relationships.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if global.IDClickedType == "family": #if the person selected is a family member, use the family arrays
		$name.text = global.familyFirstNames[global.IDClicked] + " " + global.familyLastNames[global.IDClicked]
		$details.text = global.familyTypes[global.IDClicked] + " (" + global.familySexes[global.IDClicked] + "), Age " + str(global.familyAges[global.IDClicked]) + ", Relationship: " + str(global.familyRelationships[global.IDClicked])
	else: #if the person selected is not your family
		$name.text = global.miscFirstNames[global.IDClicked] + " " + global.miscLastNames[global.IDClicked]
		$details.text = global.miscTypes[global.IDClicked] + " (" + global.miscSexes[global.IDClicked] + "), Age " + str(global.miscAges[global.IDClicked]) + ", Relationship: " + str(global.miscRelationships[global.IDClicked])
