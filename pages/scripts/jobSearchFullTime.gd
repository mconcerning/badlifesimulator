extends Node2D #author(s): Ethan Scott


@onready var scrl = get_node("scrollContainer/vBoxContainer")

const button = preload("res://objects/button_default.tscn")
const body = preload("res://objects/body.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(global.jobOpenings)
	for i in global.jobOpenings.size():
		var listing = button.instantiate()
		listing.text = global.jobOpenings[i]
		scrl.add_child(listing)
		var listingSalary = body.instantiate()
		listingSalary.text = "$" + global.commaiser(global.jobOpeningsSalary[i]) + "/yr\n"
		scrl.add_child(listingSalary)


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://pages/career_and_assets.tscn")

func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://pages/game_menu.tscn")
