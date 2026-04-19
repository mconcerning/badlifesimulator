extends Node2D #author(s): Ethan Scott


func _ready() -> void:
	if global.RAUE == true:
		$scrollContainer/centerContainer/vBoxContainer/RAUECheck.frame = 1
	else: #if global.RAUE == false
		$scrollContainer/centerContainer/vBoxContainer/RAUECheck.frame = 0


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
		$scrollContainer/centerContainer/vBoxContainer/RAUECheck.frame = 0
		global.RAUE = false
		$confirmation.text = "Successfully set RAUE to false!"
	else: #if false
		$scrollContainer/centerContainer/vBoxContainer/RAUECheck.frame = 1
		global.RAUE = true
		$confirmation.text = "Successfully set RAUE to true!"
	print("set RAUE to " + str(global.RAUE))

func _on_set_evality_pressed() -> void:
	global.evality = int($input.text)
	$confirmation.text = "Successfully set evality!"
	print("set evality to " + str(global.evality))

func _on_die_pressed() -> void:
	global.causeOfDeath = "You died because you developed too hard"
	get_tree().change_scene_to_file("res://pages/death.tscn") #kills you

func _on_set_xp_pressed() -> void:
	global.XP = int($input.text)
	$confirmation.text = "Successfully set XP!"
	print("set XP to " + str(global.XP))

func _on_set_xp_required_pressed() -> void:
	global.XPRequired = int($input.text)
	$confirmation.text = "Successfully set XPRequired!"
	print("set XPRequired to " + str(global.XPRequired))

func _on_set_xp_queued_pressed() -> void:
	global.XPQueued = int($input.text)
	$confirmation.text = "Successfully set XPQueued!"
	print("set XPQueued to " + str(global.XPQueued))

func _on_set_level_pressed() -> void:
	global.level = int($input.text)
	$confirmation.text = "Successfully set level!"
	print("set level to " + str(global.level))

func _on_set_first_name_pressed() -> void:
	global.firstName = str($input.text)
	$confirmation.text = "Successfully set first name!"
	print("set first name to " + str(global.firstName))

func _on_set_last_name_pressed() -> void:
	global.lastName = str($input.text)
	$confirmation.text = "Successfully set last name!"
	print("set last name to " + str(global.lastName))
