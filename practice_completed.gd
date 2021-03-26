extends Control

onready var time_label : Label = find_node("TimeLabel")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	var time_string = HelperFuncs.elapsedTimeMicrosecondToTimeString(SceneSwitcher.get_param("time"))
	time_label.text = time_string


func _on_Button_pressed():
	get_tree().change_scene("res://main_menu.tscn")
