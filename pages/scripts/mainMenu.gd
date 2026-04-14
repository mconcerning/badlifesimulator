extends Node2D #author(s): Ethan Scott


# Called when the node enters the scene tree for the first time. (in this case, since this is the index, on startup)
func _ready() -> void:
	$versionNumber.text = "v" + global.versionNumber #sets version number text
	if global.currentLife != "": #if there is a recent life ready to be resumed
		$continue.disabled = false #enable the continue button
	#easter eggs (don't look)
	if global.firstName == "Bob" && global.lastName == "Legacy":
		$title.text = "Chud Life Simulator"
	elif randi_range(1, 10000) == 1:
		$title.text = "Geometry Dash"


func _on_continue_pressed() -> void:
	if $continue.disabled == false: #if the continue button is enabled (you are able to continue)
		global.loadLife() #loads life


func _on_new_game_pressed() -> void: #on new game button pressed
	print("creating new random life...")
	get_tree().change_scene_to_file("res://pages/new_random_game.tscn")


func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file("res://pages/settings.tscn")


func _on_discord_pressed() -> void: #discord server invite
	OS.shell_open("https://discord.gg/DPGZ26BKTA") #opens discord invite in browser
