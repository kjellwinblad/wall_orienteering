extends CanvasLayer


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
		
