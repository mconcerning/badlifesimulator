extends Node2D #author(s): Ethan Scott


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://pages/settings.tscn")


func changeResolution(x, y):
	global.windowSize = [x, y]
	DisplayServer.window_set_size(Vector2i(global.windowSize[0], global.windowSize[1]))
	global.saveGame() #save changes to window size preferences :)
	get_tree().reload_current_scene()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if global.windowSize == [144, 256]:
		get_node("scrollContainer/vBoxContainer/144x256").disabled = true #you can't select this new resolution because it is already your resolution
	elif global.windowSize == [240, 426]:
		get_node("scrollContainer/vBoxContainer/240x426").disabled = true
	elif global.windowSize == [360, 640]:
		get_node("scrollContainer/vBoxContainer/360x640").disabled = true
	elif global.windowSize == [480, 856]:
		get_node("scrollContainer/vBoxContainer/480x856").disabled = true
	elif global.windowSize == [540, 960]:
		get_node("scrollContainer/vBoxContainer/540x960").disabled = true
	elif global.windowSize == [720, 1280]:
		get_node("scrollContainer/vBoxContainer/720x1280").disabled = true
	elif global.windowSize == [768, 1366]:
		get_node("scrollContainer/vBoxContainer/768x1366").disabled = true
	elif global.windowSize == [900, 1600]:
		get_node("scrollContainer/vBoxContainer/900x1600").disabled = true
	elif global.windowSize == [1080, 1920]:
		get_node("scrollContainer/vBoxContainer/1080x1920").disabled = true


func _on_reset_default_pressed() -> void:
	changeResolution(360, 640)

func _on_x_256_pressed() -> void:
	changeResolution(144, 256)

func _on_x_426_pressed() -> void:
	changeResolution(240, 426)

func _on_x_640_pressed() -> void:
	changeResolution(360, 640)

func _on_x_856_pressed() -> void:
	changeResolution(480, 856)

func _on_x_960_pressed() -> void:
	changeResolution(540, 960)

func _on_x_1280_pressed() -> void:
	changeResolution(720, 1280)

func _on_x_1366_pressed() -> void:
	changeResolution(768, 1366)

func _on_x_1600_pressed() -> void:
	changeResolution(900, 1600)

func _on_x_1920_pressed() -> void:
	changeResolution(1080, 1920)
