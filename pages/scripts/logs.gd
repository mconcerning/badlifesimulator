extends Node2D #author(s): Ethan Scott


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if global.logs.size() == 0:
		$scrollContainer/vBoxContainer/logs.text += "Nothing here :("
	for i in global.logs.size(): #writes all logs
		if global.logs[i] != "": #if the log isn't blank
			if i > 0: #if this isn't the first log
				$scrollContainer/vBoxContainer/logs.text += "\n"
			$scrollContainer/vBoxContainer/logs.text += global.logs[i]
	$scrollContainer.set_deferred("scroll_vertical", 99999999999)


func _on_back_pressed() -> void:
	if global.prisonSentence > 0: #if you should be in prison
		get_tree().change_scene_to_file("res://pages/prison.tscn") #takes you to prison
	else:
		get_tree().change_scene_to_file("res://pages/game_menu.tscn")
