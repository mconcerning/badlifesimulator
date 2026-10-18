extends Node2D #author(s): Ethan Scott

# FAKE POPUPS - JUST FOR FUN :)


var cautions : Array[String] = ["hat?", "ominous"]
var caution : String ##String ID of this specific caution popup


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	caution = cautions[randi_range(0, cautions.size() - 1)] #sets caution popup with an alphanumeric ID
	updatePopup()


func updatePopup():
	$heading.text = "Caution"
	$dismiss.disabled = true
	$dismiss.self_modulate.a = 0
	$yes.disabled = true
	$yes.self_modulate.a = 0
	$no.disabled = true
	$no.self_modulate.a = 0
	match caution:
		"hat?":
			$body.text = "Are you currently wearing a wide-brimmed hat?"
			$displayAnimationPlayer.play("display")
			$buttonAnimations.play("yes_no_buttons")
		"...NO HAT???":
			$body.text = "No hat, no play."
			$displayAnimationPlayer.play("display")
			$buttonAnimations.play("dismiss_button")
		"ominous":
			$heading.text = ""
			$body.text = ""
			$image.frame = 0
			$buttonAnimations.play("dismiss_image")


func _on_dismiss_pressed() -> void:
	match caution:
		"...NO HAT???":
			if OS.get_name() == "iOS" || OS.get_name() == "Web": #simply closing the game will do nothing on any iOS or web builds of the game
				caution = "hat?"
				updatePopup()
			else:
				get_tree().quit()
		"ominous":
			get_tree().change_scene_to_file("res://pages/main_menu.tscn")


func _on_yes_pressed() -> void:
	match caution:
		"hat?":
			get_tree().change_scene_to_file("res://pages/main_menu.tscn")


func _on_no_pressed() -> void:
	match caution:
		"hat?":
			caution = "...NO HAT???"
			updatePopup()
