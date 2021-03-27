extends Control

onready var time_label : Label = find_node("TimeLabel")
onready var viewport : Viewport = find_node("Viewport")
onready var viewport_center_container = find_node("ViewportCenterContainer")
onready var viewport_container = find_node("ViewportContainer")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if SceneSwitcher.get_param("time"):
		var time_string = HelperFuncs.elapsedTimeMicrosecondToTimeString(SceneSwitcher.get_param("time"))
		time_label.text = time_string
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	print(viewport_center_container.rect_size)
	viewport.size = viewport_center_container.rect_size
	viewport_container.rect_size = viewport_center_container.rect_size
	viewport_container.rect_min_size = viewport_center_container.rect_size

func _on_Button_pressed():
	get_tree().change_scene("res://main_menu.tscn")


func _on_ViewportCenterContainer_resized():
	viewport.size = viewport_center_container.rect_size
	viewport_container.rect_size = viewport_center_container.rect_size
	viewport_container.rect_min_size = viewport_center_container.rect_size
	print("changed_size", viewport_center_container.rect_size)
