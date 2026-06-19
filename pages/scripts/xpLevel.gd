extends Node2D #author(s): Ethan Scott


func levelAliasFinder(): ##Gives you a cool rank name based on what level you are.
	var superLevel = floori(float(global.level - 1) / 4) ##Your superlevel increments every 4 actual levels (the 4th level is included in the previous chunk; that is to say level 4 will equal the same superlevel as level 1 and level 8 will equal the same superlevel as level 5. The actual levels where your superlevels will change are the ones after each level divisible by 4, so 5, 9, 13, 17... This is because your level starts at 1 and not 0.
	#sets the text based on how many sets of 4 levels you've absolutely traversed
	var rankNames = ["Embryo", "Fetus", "Newborn", "Toddler", "Child", "Tween", "Teenager", "Adult", "Old", "Super old", "Unbelievably old", "Withering away old", "Practically elderly", "30 years old", "Beginner", "Novice", "Newcomer", "Rookie", "Amatuer", "Newbie", "Just starting out", "New to all this", "Learning the ropes", "New kid on the block", "The student", "The marginally improved student", "World's leading expert", "Unemployed", "Has a costco membership", "Plays the cello", "Secretly Elliot Taylor's level", "Single-celled organism", "Organelle", "Amoeba", "Bacteria", "Virus"] ##The aliases! In the order they appear. Index 0 will cover levels 1 - 4, index 1 will cover levels 5 - 8, index 2 will cover levels 9 - 13, etc.
	if superLevel >= rankNames.size():
		$XPText.text += "I ran out of names"
	else:
		$XPText.text += rankNames[superLevel]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$levelText.text = "Level " + global.commaiser(global.level)
	$progressBar.max_value = global.XPRequired
	$progressBar.value = global.XP
	$XPText.text = global.commaiser(global.XP) + " / " + global.commaiser(global.XPRequired) + "\nXP\n\n"
	levelAliasFinder()


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://pages/main_menu.tscn")
