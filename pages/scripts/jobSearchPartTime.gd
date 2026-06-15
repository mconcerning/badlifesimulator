extends Node2D #author(s): Ethan Scott


@onready var scrl = get_node("scrollContainer/vBoxContainer")

const button = preload("res://objects/button_default.tscn")
const body = preload("res://objects/body.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in global.partTimeJobOpenings.size():
		var partTimeJob = button.instantiate()
		partTimeJob.text = global.partTimeJobOpenings[i][0]
		scrl.add_child(partTimeJob)
		var details = body.instantiate()
		details.text = "Rate: $" + global.commaiser(global.partTimeJobOpenings[i][1]) + "/hr\nHours: " + global.commaiser(global.partTimeJobOpenings[i][2]) + "/wk\nPay per year: $" + global.commaiser(global.partTimeJobOpenings[i][1] * global.partTimeJobOpenings[i][2] * global.partTimeWorkWeeksPerAnnum) #rate * hours * weeks per hour
		scrl.add_child(details)
		if details.size.x > 960: #caps the details text length at 960 pixels; if it's longer, enable autowrap
			details.custom_minimum_size.x = 960
			details.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://pages/career_and_assets.tscn")

func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://pages/game_menu.tscn")
