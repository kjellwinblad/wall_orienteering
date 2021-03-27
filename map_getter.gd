extends Node

func get_practce_maps() -> Array:
	var maps_dir : String = "res:///maps/"
	var map_files = list_files_in_directory(maps_dir)
	map_files.sort()
	var practice_maps = []
	for f in map_files:
		var file_name :String = f
		if file_name.begins_with("practice_") and file_name.ends_with(".tres"):
			practice_maps.append(maps_dir + file_name)
	var practice_map_resources = []
	for p in practice_maps:
		practice_map_resources.append(load(p))
	return practice_map_resources

func list_files_in_directory(path):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(file)

	dir.list_dir_end()

	return files
