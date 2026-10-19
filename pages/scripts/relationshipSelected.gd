extends Node2D #author(s): Ethan Scott


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://pages/relationships.tscn")

func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://pages/game_menu.tscn")

func _on_more_info_pressed() -> void:
	get_tree().change_scene_to_file("res://pages/relationship_selected_more_info.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$type.text = global.personTypes[global.IDClicked]
	$name.text = global.personFirstNames[global.IDClicked] + " " + global.personLastNames[global.IDClicked]
	var gender : String = global.personGenders[global.IDClicked]
	if global.personSexes[global.IDClicked] != global.personGenders[global.IDClicked]:
		gender = global.personSexes[global.IDClicked] + "t" + global.personGenders[global.IDClicked]
	$details.text = "(" + gender + "), Age " + str(global.personAges[global.IDClicked]) + ", Relationship: " + str(global.personRelationships[global.IDClicked])
	if global.age < 3 || global.personAges[global.IDClicked] < 3: #if you're really young, or they're really young (2 or younger)
		$scrollContainer/centerContainer/vBoxContainer/compliment.disabled = true #you can't talk -> you can't compliment
	$scrollContainer/centerContainer/vBoxContainer/compliment.text += global.pronounGenerator("him", global.personGenders[global.IDClicked])


func _on_compliment_pressed() -> void:
	global.revent.append("compliment-relationship")
	get_tree().change_scene_to_file("res://pages/event.tscn")
