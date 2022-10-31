extends Control

onready var time_label : Label = find_node("TimeLabel")
onready var viewport : Viewport = find_node("Viewport")
onready var viewport_center_container = find_node("ViewportCenterContainer")
onready var viewport_container = find_node("ViewportContainer")

var upload_result_page = preload("res://UploadResult.tscn")
var map = null
var race_path = null

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if SceneSwitcher.get_param("time"):
		var time_string = HelperFuncs.elapsedTimeMicrosecondToTimeString(SceneSwitcher.get_param("time"))
		time_label.text = time_string
	if SceneSwitcher.get_param("map"):
		map = SceneSwitcher.get_param("map")
	if SceneSwitcher.get_param("race_path"):
		race_path = SceneSwitcher.get_param("race_path")
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	viewport.size = viewport_center_container.rect_size
	viewport_container.rect_size = viewport_center_container.rect_size
	viewport_container.rect_min_size = viewport_center_container.rect_size

func _on_Button_pressed():
	get_tree().change_scene("res://main_menu.tscn")


func _on_ViewportCenterContainer_resized():
	viewport.size = viewport_center_container.rect_size
	viewport_container.rect_size = viewport_center_container.rect_size
	viewport_container.rect_min_size = viewport_center_container.rect_size


func _on_UploadResultButton_pressed():
	SceneSwitcher.change_scene("res://UploadResult.tscn",
	{"time": SceneSwitcher.get_param("time"),
	 "map": SceneSwitcher.get_param("map"),
	 "race_path": SceneSwitcher.get_param("race_path"),
	 "back_scene":  "res://PracticeCompleted.tscn"})


func _on_ViewResultsButton_pressed():
	SceneSwitcher.change_scene("res://ResultList.tscn", 
		{"time": SceneSwitcher.get_param("time"),
		"race_path": SceneSwitcher.get_param("race_path"),
		"map": SceneSwitcher.get_param("map"),
		"back_scene":  "res://PracticeCompleted.tscn"})
