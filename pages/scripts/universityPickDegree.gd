extends Node2D #author(s): Ethan Scott


const scrl = "scrollContainer/centerContainer/vBoxContainer/"


func go(): ##goes
	if global.revent.size() > 0 && global.revent[0] == "graduated-high-school-o2":
		global.revent[0] = "university-degree-picked"
	else:
		global.revent.push_front("university-degree-picked")
	get_tree().change_scene_to_file("res://pages/event.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if global.degrees.has("Education"):
		get_node(scrl + "education").disabled = true
	if global.degrees.has("Law"):
		get_node(scrl + "law").disabled = true


func _on_cancel_pressed() -> void:
	global.revent.pop_front()
	get_tree().change_scene_to_file("res://pages/game_menu.tscn")


#degrees
func _on_education_pressed() -> void:
	global.degreePicked = "Education"
	go()

func _on_law_pressed() -> void:
	global.degreePicked = "Law"
	go()
