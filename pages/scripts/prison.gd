extends Node2D #author(s): Ethan Scott


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global.statClamper()
	#stat text setting
	$name.text = str(global.firstName) + " " + str(global.lastName)
	$age.text = "Age: " + str(global.age)
	$joy.text = "Joy: " + str(global.joy)
	$health.text = "Health: " + str(global.health)
	$intellect.text = "Intellect: " + str(global.intellect)
	$looks.text = "Looks: " + str(global.looks)
	$prison.position.y = 20 + $name.position.y + $name.size.y
	$gender.text = global.sex
	if global.age < 18: #if you are a juvenile
		$prison.text = "Juvenile detention"
	if global.logs.size() == 0: #if there aren't logs to show
		$logsMenu.hide() #hides the logs menu button
	if global.revent.size() != 0: #if there are random events queued
		get_tree().change_scene_to_file("res://pages/event.tscn")
	global.saveGame() #saves both life and game files (does not need to go before the line above as saveGame() is run when the event.gd script is initialised anyway)


func _on_new_game_egg_mouse_entered() -> void: #when the mouse is hovered over the new game egg button
	$newGameEgg.scale = Vector2(1.1, 1.1) #increases size by 10%

func _on_new_game_egg_mouse_exited() -> void: #when the mouse leaves hovering the new game egg button
	$newGameEgg.scale = Vector2(1, 1) #sets size back to normal

func _on_new_game_egg_pressed() -> void: #on new game egg button clicked
	get_tree().change_scene_to_file("res://pages/new_game_confirmation.tscn")
