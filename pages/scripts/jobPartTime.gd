extends Node2D #author(s): Ethan Scott


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://pages/career_and_assets.tscn")

func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://pages/game_menu.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$jobName.text = global.partTimeJob
	$performance.text = "Performance: " + str(global.partTimePerformance)
	$payAndHours.text = "Rate: $" + global.commaiser(global.partTimeRate) + "/hr | Hours: " + global.commaiser(global.partTimeHours) + "/wk"
	$salary.text = "Pay per year: $" + global.commaiser(global.partTimeSalary())
