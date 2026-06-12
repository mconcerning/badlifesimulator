extends Node2D #author(s): Ethan Scott


const scrl = "scrollContainer/centerContainer/vBoxContainer/"


func go(isQualified = true): ##goes
	if isQualified == true:
		global.revent.push_front("certificate-picked")
	elif isQualified == false: #if you're unqualified
		global.revent.push_front("certificate-unqualified")
	get_tree().change_scene_to_file("res://pages/event.tscn")


func qualificationCheck(): ##Checks if you have the appropriate prerequisite education needed to take this certificate
	match global.degreePicked:
		"Electrical engineering": #if you've picked a certificate in electrical engineering, checks if you have the degree needeed
			if global.degrees.has("Engineering"):
				go()
			else: #if you're not qualified
				go(false)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if global.certificates.has("Plumbery"):
		get_node(scrl + "plumbery").disabled = true
	if global.certificates.has("Electrical engineering"):
		get_node(scrl + "electricalEngineering").disabled = true


func _on_cancel_pressed() -> void:
	get_tree().change_scene_to_file("res://pages/game_menu.tscn")


#degrees
func _on_plumbery_pressed() -> void:
	global.degreePicked = "Plumbery"
	go()

func _on_electrical_engineering_pressed() -> void:
	global.degreePicked = "Electrical engineering"
	qualificationCheck()
