extends Node2D #author(s): Ethan Scott


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	match global.schoolLevel:
		1:
			$schoolType.text = "Primary school"
		2:
			$schoolType.text = "High school"
		3:
			$schoolType.text = "Majoring in " + global.degreePicked
		-1: #you're not in school? but you somehow still got here??
			$schoolType.text = "NOT school?"
	$schoolName.text = global.schoolName
	$performance.text = "Performance: " + str(global.schoolPerformance)
	if global.schoolPerformance <= 35: #if you're underperforming and at risk of being expelled
		$performance.label_settings.font_color = Color.from_rgba8(200, 0, 0, 255) #makes the font colour of the performance text only (it has a unique LabelSettings resource) dark red to signify danger
	elif global.schoolPerformance >= 80: #if you're doing really well at school
		$performance.label_settings.font_color = Color.from_rgba8(0, 170, 0, 255) #makes the text green to signify you're doing well :)
	else: #if you're doing fine in school
		$performance.label_settings.font_color = Color.from_rgba8(0, 0, 0, 255)


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://pages/career_and_assets.tscn") #takes you back to careers and assets

func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://pages/game_menu.tscn") #takes you back to the game menu


func _on_study_harder_pressed() -> void:
	global.revent.append("study-harder")
	get_tree().change_scene_to_file("res://pages/event.tscn")

func _on_skip_class_pressed() -> void:
	global.revent.append("skip-class")
	get_tree().change_scene_to_file("res://pages/event.tscn")
