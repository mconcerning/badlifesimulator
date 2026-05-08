extends Label #author(s): Ethan Scott


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if global.money < 0: #if you are in debt
		label_settings.font_color = Color("b20011ff")
	elif global.money == 0: #if you are completely neutral
		label_settings.font_color = Color("000000ff")
	elif global.money > 0: #if you are in the green
		label_settings.font_color = Color("#008000ff")
	#comma-iser
	text = "Money: $" + global.commaiser(global.money)
