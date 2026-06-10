extends Node2D #author(s): Ethan Scott


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://pages/career_and_assets.tscn")

func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://pages/game_menu.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$timeType.text = "Full-time job"
	$jobName.text = global.fullTimeJob
	$performance.text = "Performance: " + str(global.fullTimePerformance)
	if global.fullTimePerformance <= 35: #if you're underperforming and at risk of being fired
		$performance.label_settings.font_color = Color.from_rgba8(200, 0, 0, 255) #makes the font colour of the performance text only (it has a unique LabelSettings resource) dark red to signify danger
	elif global.fullTimePerformance >= 80: #if you're doing really well at your job
		$performance.label_settings.font_color = Color.from_rgba8(0, 170, 0, 255) #makes the text green to signify you're doing well :) 
	else: #if you're doing fine
		$performance.label_settings.font_color = Color.from_rgba8(0, 0, 0, 255)
	$effects.text = "Effects: " + global.allJobs[global.findJob(global.fullTimeJob)][3]


func _on_extra_effort_pressed() -> void:
	global.revent.append("full-time-extra-effort")
	get_tree().change_scene_to_file("res://pages/event.tscn")


func _on_quit_pressed() -> void:
	global.revent.append("full-time-quit-confirm")
	get_tree().change_scene_to_file("res://pages/event.tscn")
