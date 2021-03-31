extends Control

class_name UploadResult

onready var name_line_edit:LineEdit = find_node("NameLineEdit")

export(Resource) onready var map = map as MapResource
export(String) onready var result_name = result_name as String
#export(Resource) onready var race_path = race_path as RacePathResouce
export(int) onready var time = time as int


var back_scene = null

onready var http_request : HTTPRequest = find_node("HTTPRequest")
const DOMAIN : String = "http://127.0.0.1:5000"
const GET_RES_LIST_URL : String = DOMAIN + "/add_to_result_list/"

var result_list_scene = preload("res://ResultList.tscn")

func get_res_list_upload_url():
	return GET_RES_LIST_URL + map.hash_value

func _ready():
	print("upload path", SceneSwitcher.get_param("race_path"), SceneSwitcher.get_param("race_path").points)
	if SceneSwitcher.get_param("back_scene"):
		back_scene = SceneSwitcher.get_param("back_scene")
	if SceneSwitcher.get_param("time"):
		time = SceneSwitcher.get_param("time")
#	if SceneSwitcher.get_param("race_path"):
#		race_path = SceneSwitcher.get_param("race_path")
	if SceneSwitcher.get_param("map"):
		map = SceneSwitcher.get_param("map")

func _on_HTTPRequest_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray):
	if body.get_string_from_utf8() == "ok":
		SceneSwitcher.change_scene("res://ResultList.tscn", 
		{"time": SceneSwitcher.get_param("time"),
		"race_path": SceneSwitcher.get_param("race_path"),
		"map": SceneSwitcher.get_param("map"),
		"back_scene":  "res://PracticeCompleted.tscn"})


func _on_Button2_pressed():
	# Convert data to json string:
	result_name = find_node("NameLineEdit").text
	if result_name == "":
		find_node("TypeNameDialog").popup()
		return
	var query = JSON.print({"name": result_name, "time": time, "route":SceneSwitcher.get_param("race_path").to_json_string()})
	# Add 'Content-Type' header:
	var headers = ["Content-Type: application/json"]
	print("Sending request")
	http_request.request(get_res_list_upload_url(), headers, false, HTTPClient.METHOD_POST, query)


func _on_Button_pressed():
	print("Back Race Path", SceneSwitcher.get_param("race_path"), SceneSwitcher.get_param("race_path").points)
	SceneSwitcher.get_param("race_path").points = SceneSwitcher.get_param("race_path").points.duplicate()
	SceneSwitcher.get_param("race_path").times = SceneSwitcher.get_param("race_path").times.duplicate()
	var params = {"time": SceneSwitcher.get_param("time"),
	 "race_path": SceneSwitcher.get_param("race_path").duplicate(),
	"what":SceneSwitcher.get_param("race_path").points.duplicate(),
	"what2":"HEJ", 
	"map": SceneSwitcher.get_param("map"),
	 "back_scene":  "res://main_menu.tscn"}
	SceneSwitcher.change_scene(back_scene, params)
