extends Control

var loaded_map: MapResource = null

func _ready():
	loaded_map = SceneSwitcher.get_param("map")
	find_node("TitleLabel").text = loaded_map.name

func _on_StartButton_pressed():
	SceneSwitcher.change_scene("res://Race.tscn", {"map": loaded_map})


func _on_ResultsButton_pressed():
	SceneSwitcher.change_scene("res://ResultList.tscn", 
		{"map": SceneSwitcher.get_param("map"),
		"back_scene":  "res://PracticeIntro.tscn"})


func _on_Back_pressed():
	self.queue_free()
	get_tree().change_scene("res://SelectPracticeMap.tscn")
