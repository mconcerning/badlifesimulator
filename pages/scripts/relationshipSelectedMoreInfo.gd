extends Node2D #author(s): Ethan Scott


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://pages/relationship_selected.tscn")

func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://pages/game_menu.tscn")


func statFind(statName : String): ##Returns the value of one of this person's stats.
	return global.personStats[global.IDClicked][global.personStatsDictionary.find(statName)]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$type.text = global.personTypes[global.IDClicked]
	$name.text = global.personFirstNames[global.IDClicked] + " " + global.personLastNames[global.IDClicked]
	$details.text = "(" + global.personSexes[global.IDClicked] + "), Age " + str(global.personAges[global.IDClicked]) + ", Relationship: " + str(global.personRelationships[global.IDClicked])
	$scrollContainer/info.text += "Joy: " + str(statFind("Joy")) + "\nHealth: " + str(statFind("Health")) + "\nIntellect: " + str(statFind("Intellect")) + "\nLooks: " + str(statFind("Looks"))
