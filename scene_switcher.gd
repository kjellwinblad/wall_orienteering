extends Node

# Private variable
var _params = null

# Call this instead to be able to provide arguments to the next scene
func change_scene(next_scene, params=null):
	_params = params
	var err = get_tree().change_scene(next_scene)
	if err != OK:
		print("change_scene error")

# In the newly opened scene, you can get the parameters by name
func get_param(name):
	if _params != null and _params.has(name):
		return _params[name]
	return null

func clear_params():
	_params = null
