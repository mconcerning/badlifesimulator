extends Node2D #author(s): Ethan Scott


const scrl = "scrollContainer/centerContainer/vBoxContainer/"


func go(): ##goes
	global.revent.push_front("certificate-picked")
	get_tree().change_scene_to_file("res://pages/event.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if global.certificates.has("Plumbery"):
		get_node(scrl + "plumbery").disabled = true


func _on_cancel_pressed() -> void:
	get_tree().change_scene_to_file("res://pages/game_menu.tscn")


#degrees
func _on_plumbery_pressed() -> void:
	global.degreePicked = "Plumbery"
	go()
