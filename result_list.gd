extends Control

class_name ResultList

onready var result_list_conatiner: VBoxContainer = find_node("ResultListContainer")
onready var http_request : HTTPRequest = find_node("HTTPRequest")
var GET_RES_LIST_URL : String = Constants.DOMAIN + "/get_result_list/"
var result_list_item_preload = preload("res:///ResultListItem.tscn")

export(Resource) onready var map = map as MapResource 

func _ready():
	if SceneSwitcher.get_param("map"):
		map = SceneSwitcher.get_param("map")
	load_from_internet()

func get_res_list_url():
	return GET_RES_LIST_URL + map.hash_value


func load_from_internet():
	print("SENDING REQUEST")
	http_request.request(get_res_list_url(), ["user-agent: wall_orientering"])

static func delete_children(node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()


func _on_HTTPRequest_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray):
	var json: JSONParseResult = JSON.parse(body.get_string_from_utf8())
	var result_List = json.result.results
	delete_children(result_list_conatiner)
	var rank := 1
	for result in result_List:
		var result_list_item : ResultListItem =  result_list_item_preload.instance()
		result_list_item.result_name = result.name
		result_list_item.rank = rank
		result_list_item.time = int(result.time)
		rank += 1
		result_list_conatiner.add_child(result_list_item)


func _on_Button_pressed():
	SceneSwitcher.change_scene(SceneSwitcher.get_param("back_scene"),
	{"time": SceneSwitcher.get_param("time"),
	 "race_path": SceneSwitcher.get_param("race_path"),
	 "map": SceneSwitcher.get_param("map"),
	 "back_scene":  "res://main_menu.tscn"})
