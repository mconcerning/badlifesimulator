extends Node2D #author(s): Ethan Scott


@onready var scrl = get_node("scrollContainer/vBoxContainer")

const button = preload("res://objects/button_default.tscn")
const body = preload("res://objects/body.tscn")


func jobSelect(jobIndex : int): ##Runs when you click a job to view more details; jobIndex is the index of the job you selected in the array global.jobOpenings.
	print("selected job at index " + str(jobIndex))
	global.IDClicked = jobIndex #we can technically use IDClicked to keep track of which job you selected, among other things, not just relationships...
	get_tree().change_scene_to_file("res://pages/job_apply.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in global.jobOpenings.size():
		var listing = button.instantiate()
		listing.text = global.jobOpenings[i][0]
		listing.pressed.connect(jobSelect.bind(i))
		scrl.add_child(listing)
		var moreDetails = body.instantiate()
		moreDetails.text = "$" + global.commaiser(global.jobOpenings[i][1]) + "/yr\nRequires: " + global.jobOpenings[i][2] + "\n"
		scrl.add_child(moreDetails)
		if moreDetails.size.x > 960: #caps the details text length at 960 pixels; if it's longer, enable autowrap
			moreDetails.custom_minimum_size.x = 960
			moreDetails.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://pages/career_and_assets.tscn")

func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://pages/game_menu.tscn")
