extends Node2D #author(s): Ethan Scott


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in global.logs.size(): #writes all logs
		if global.logs[i] != "": #if the log isn't blank
			if i > 0: #if there are logs to show
				$scrollContainer/vBoxContainer/logs.text += "\n"
			$scrollContainer/vBoxContainer/logs.text += global.logs[i]
	$scrollContainer.set_deferred("scroll_vertical", 99999999999)
	await get_tree().process_frame
	print($scrollContainer.scroll_vertical)


func _on_back_pressed() -> void:
	if global.prisonSentence > 0: #if you should be in prison
		get_tree().change_scene_to_file("res://pages/prison.tscn") #takes you to prison
	else:
		get_tree().change_scene_to_file("res://pages/game_menu.tscn")
