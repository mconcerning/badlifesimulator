extends Node2D #author(s): Ethan Scott


func _ready() -> void:
	if global.RAUE == true:
		$scrollContainer/control/RAUECheck.frame = 1
	else: #if global.RAUE == false
		$scrollContainer/control/RAUECheck.frame = 0


func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://pages/new_game_confirmation.tscn") #go back


func _on_save_game_pressed() -> void:
	get_tree().change_scene_to_file("res://pages/save_game.tscn")


func _on_set_age_pressed() -> void:
	global.age = int($input.text)
	$confirmation.text = "Successfully set age!"
	print("set age to " + str(global.age))

func _on_set_joy_pressed() -> void:
	global.joy = int($input.text)
	$confirmation.text = "Successfully set joy!"
	print("set joy to " + str(global.joy))

func _on_set_health_pressed() -> void:
	global.health = int($input.text)
	$confirmation.text = "Successfully set health!"
	print("set health to " + str(global.health))

func _on_set_intellect_pressed() -> void:
	global.intellect = int($input.text)
	$confirmation.text = "Successfully set intellect!"
	print("set intellect to " + str(global.intellect))

func _on_set_looks_pressed() -> void:
	global.looks = int($input.text)
	$confirmation.text = "Successfully set looks!"
	print("set looks to " + str(global.looks))

func _on_raue_pressed() -> void:
	if global.RAUE == true:
		$scrollContainer/control/RAUECheck.frame = 0
		global.RAUE = false
		$confirmation.text = "Successfully set RAUE to false!"
	else: #if false
		$scrollContainer/control/RAUECheck.frame = 1
		global.RAUE = true
		$confirmation.text = "Successfully set RAUE to true!"
	print("set RAUE to " + str(global.RAUE))

func _on_set_evality_pressed() -> void:
	global.evality = int($input.text)
	$confirmation.text = "Successfully set evality!"
	print("set evality to " + str(global.evality))

func _on_die_pressed() -> void:
	get_tree().change_scene_to_file("res://pages/death.tscn") #kills you
