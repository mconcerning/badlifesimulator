extends Node2D #author(s): Ethan Scott


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if str(global.prisonSentence) == "Life" || int(global.prisonSentence) > 0: #if you're supposed to be in prison
		get_tree().change_scene_to_file("res://pages/prison.tscn")
		return
	global.statClamper()
	#stat text setting
	$name.text = str(global.firstName) + " " + str(global.lastName)
	$age.text = "Age: " + str(global.age)
	$joy.text = "Joy: " + str(global.joy)
	$health.text = "Health: " + str(global.health)
	$intellect.text = "Intellect: " + str(global.intellect)
	$looks.text = "Looks: " + str(global.looks)
	if global.revent.size() != 0: #if there are random events queued
		get_tree().change_scene_to_file("res://pages/event.tscn")
	global.saveGame() #saves both life and game files (does not need to go before the line above as saveGame() is run when the event.gd script is initialised anyway)


func _on_new_game_egg_mouse_entered() -> void: #when the mouse is hovered over the new game egg button
	$newGameEgg.scale = Vector2(1.1, 1.1) #increases size by 10%

func _on_new_game_egg_mouse_exited() -> void: #when the mouse leaves hovering the new game egg button
	$newGameEgg.scale = Vector2(1, 1) #sets size back to normal

func _on_new_game_egg_pressed() -> void: #on new game egg button clicked
	get_tree().change_scene_to_file("res://pages/new_game_confirmation.tscn")


func _on_age_up_button_pressed() -> void: #on age up button pressed
	get_tree().change_scene_to_file("res://pages/age_up.tscn") #age up


func _on_logs_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://pages/logs.tscn")


func _on_occupation_pressed() -> void:
	if global.schoolLevel == -1: #if you don't go to school yet
		global.revent.append("child-labour-is-outlawed")
		get_tree().change_scene_to_file("res://pages/event.tscn") #child labour is thoroughly illegal. Unless...
	elif global.schoolLevel == 1 || global.schoolLevel == 2 || global.schoolLevel == 3: #if you do go to school
		get_tree().change_scene_to_file("res://pages/school.tscn") #go to school

func _on_relationships_pressed() -> void:
	get_tree().change_scene_to_file("res://pages/relationships.tscn")


#keyboard shortcuts
func _unhandled_input(event: InputEvent) -> void: #if you make an input that godot isn't handling
	if event.is_action_pressed("gamemenu_occupation"):
		_on_occupation_pressed()
	elif event.is_action_pressed("gamemenu_relationships"):
		_on_relationships_pressed()
	elif event.is_action_pressed("ui_accept"): #if enter is pressed
		_on_age_up_button_pressed()
