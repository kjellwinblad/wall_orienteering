extends CanvasLayer

onready var open_from_file_dialog : FileDialog = find_node("FileDialog")

func _ready():
	var base_load_map_component = find_node("LoadMapComponent")
	var map_resources : Array = MapGetter.get_practce_maps()
	var map_list_container : Node = find_node("MapListContainer")
	for r in map_resources:
		var map_resource : MapResource = r
		print(r, r is MapResource)
		var load_map_component = find_node("LoadMapComponent").duplicate()
		load_map_component.map = map_resource
		load_map_component.visible = true
		map_list_container.add_child(load_map_component)
		


func _on_Back_pressed():
	self.queue_free()
	get_tree().change_scene("res://main_menu.tscn")


func _on_OpenMapFromFileButton_pressed():
	open_from_file_dialog.invalidate()
	open_from_file_dialog.popup()


func _on_FileDialog_file_selected(path):
	var loaded_map = load(path)
	if not (loaded_map is MapResource):
		find_node("IncorrectMapDialog").visible = true
	else:
		loaded_map = loaded_map as MapResource
		SceneSwitcher.change_scene("res://Race.tscn", {"map": loaded_map})
