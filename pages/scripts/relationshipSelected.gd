extends Node2D #author(s): Ethan Scott


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://pages/relationships.tscn")

func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://pages/game_menu.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if global.IDClickedType == "family": #if the person selected is a family member, use the family arrays
		$type.text = global.familyTypes[global.IDClicked]
		$name.text = global.familyFirstNames[global.IDClicked] + " " + global.familyLastNames[global.IDClicked]
		$details.text = "(" + global.familySexes[global.IDClicked] + "), Age " + str(global.familyAges[global.IDClicked]) + ", Relationship: " + str(global.familyRelationships[global.IDClicked])
		$scrollContainer/centerContainer/vBoxContainer/conversation.text += global.pronounGenerator("him", global.familySexes[global.IDClicked])
	else: #if the person selected is not your family
		$type.text = global.miscTypes[global.IDClicked]
		$name.text = global.miscFirstNames[global.IDClicked] + " " + global.miscLastNames[global.IDClicked]
		$details.text = "(" + global.miscSexes[global.IDClicked] + "), Age " + str(global.miscAges[global.IDClicked]) + ", Relationship: " + str(global.miscRelationships[global.IDClicked])
		$scrollContainer/centerContainer/vBoxContainer/conversation.text += global.pronounGenerator("him", global.miscSexes[global.IDClicked])


func _on_conversation_pressed() -> void:
	global.revent.append("conversation-with-relationship")
	get_tree().change_scene_to_file("res://pages/event.tscn")
