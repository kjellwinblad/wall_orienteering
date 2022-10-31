extends Control



enum EditorState {
	SELECT_STATE,
	ADD_WALL_STATE,
	DELETE_STATE,
	ADD_CONTROL_STATE,
	SET_START_STATE,
	SET_GOAL_STATE
}

var state = EditorState.SELECT_STATE
var _mouse_pos := Vector2()
var _click_one := Vector2.INF
var entered_item = null
onready var _ray_cast : RayCast = find_node("RayCast")
onready var _pos_label = find_node("PosLabel")
onready var map_renderer : MapRenderer = find_node("MapRenderer")
onready var camera : Camera = find_node("Camera")
onready var map_renderer_scene = preload("map_renderer.tscn")
onready var editor_menu : EditorMenu = find_node("EditorMenu")
onready var properties_dialog : SetSizeDialog = find_node("PropertiesDialog")
onready var help_label: Label = find_node("HelpLabel")
onready var viewport: Viewport = find_node("Viewport")
onready var viewport_center_container = find_node("ViewportCenterContainer")
onready var viewport_container = find_node("ViewportContainer")

func _ready():
	var err = editor_menu.connect("id_pressed", self, "_on_menu_select")
	if err != OK:
		print("error editor_menu.connect(id_pressed)")
	err =  editor_menu.connect("mouse_entered", self, "_on_menu_entered")
	if err != OK:
		print("error editor_menu.connect(mouse_entered)")
	if SceneSwitcher.get_param("map"):
		map_renderer.set_map(SceneSwitcher.get_param("map"))
	viewport.size = viewport_center_container.rect_size
	viewport_container.rect_size = viewport_center_container.rect_size
	viewport_container.rect_min_size = viewport_center_container.rect_size
	rerender_map()

func _on_menu_select(id):
	if id == editor_menu.MenuItemId.ADD_WALL:
		state = EditorState.ADD_WALL_STATE
		help_label.text = "[Add Wall Mode] Make one click where the wall shall start and one click where it shall end"
		return
	if id == editor_menu.MenuItemId.SELECT_MODE:
		state = EditorState.SELECT_STATE
	if id == editor_menu.MenuItemId.DELETE_MODE:
		state = EditorState.DELETE_STATE
		help_label.text = "[Remove Mode] Click on item to remove"
		return
	if id == editor_menu.MenuItemId.ADD_CONTROL:
		state = EditorState.ADD_CONTROL_STATE
		help_label.text = "[Add Control Mode] Click to place control"
		return
	if id == editor_menu.MenuItemId.CLEAR_WALLS:
		map_renderer.get_map().walls = []
		rerender_map()
	if id == editor_menu.MenuItemId.CLEAR_CONTROLS:
		map_renderer.get_map().controlls = []
		rerender_map()
	if id == editor_menu.MenuItemId.SAVE:
		find_node("SaveFileDialog").invalidate()
		find_node("SaveFileDialog").popup()
		find_node("SaveFileDialog").invalidate()
	if id == editor_menu.MenuItemId.OPEN:
		find_node("OpenFileDialog").invalidate()
		find_node("OpenFileDialog").popup()
		find_node("OpenFileDialog").invalidate()
	if id == editor_menu.MenuItemId.SET_GROUND_SIZE:
		properties_dialog.popup_with_map(map_renderer.get_map())
	if id == editor_menu.MenuItemId.SET_START_MODE:
		state = EditorState.SET_START_STATE
		help_label.text = "[Set Start Location Mode] Click to select start location"
		return
	if id == editor_menu.MenuItemId.SET_GOAL_MODE:
		state = EditorState.SET_GOAL_STATE
		help_label.text = "[Set Goal Location Mode] Click to select goal location"
		return
	if id == editor_menu.MenuItemId.TO_MAIN_MENU:
		var err = get_tree().change_scene("res://main_menu.tscn")
		if err != OK:
			print("error get_tree().change_scene(res://main_menu.tscn)")
		self.queue_free()
	help_label.text = ""

func _on_menu_entered():
	state = EditorState.SELECT_STATE
	help_label.text = ""

func _on_add_wall_pressed():
	state = EditorState.ADD_WALL_STATE

func _input(event):
	var mouse_motion_event = event as InputEventMouseMotion
	var mouse_click_event = event as InputEventMouseButton
	if mouse_motion_event:
		handle_mouse_motion_event(mouse_motion_event)
	if mouse_click_event:
		handle_mouse_click_event(mouse_click_event)
	if Input.is_action_just_pressed("add_control"):
		editor_menu.emit_signal("id_pressed", editor_menu.MenuItemId.ADD_CONTROL)
	if Input.is_action_just_pressed("add_wall"):
		editor_menu.emit_signal("id_pressed", editor_menu.MenuItemId.ADD_WALL)
	if Input.is_action_just_pressed("delete"):
		editor_menu.emit_signal("id_pressed", editor_menu.MenuItemId.DELETE_MODE)

func handle_mouse_motion_event(_mouse_event:InputEventMouseMotion):
	var dropPlane  = Plane(Vector3(0,0,0), Vector3(10,0,0), Vector3(10,0,10))
	var mouse_pos_map_viewport = viewport.get_mouse_position()
	var mousePosition3D = dropPlane.intersects_ray(
							 camera.project_ray_origin(mouse_pos_map_viewport),
							 camera.project_ray_normal(mouse_pos_map_viewport))
	if editor_menu.snap_to_meters:
		_mouse_pos = Vector2(round(mousePosition3D.x), round(mousePosition3D.z))
	else:
		_mouse_pos = Vector2(mousePosition3D.x, mousePosition3D.z)
	find_node("MeshInstance").transform.origin = mousePosition3D
	#_ray_cast.enabled = true
	#_ray_cast.transform.origin = camera.project_ray_origin(mouse_event.position)
	#_ray_cast.look_at_from_position(camera.project_ray_origin(mouse_event.position), mousePosition3D, Vector3.UP)
	
	#_ray_cast.cast_to = mousePosition3D
	var colliding_body : StaticBody = _ray_cast.get_collider()
	var item = item_from_colliding_body(colliding_body)
	if entered_item:
		entered_item._mouse_exited()
	if item:
		entered_item = item
		item._mouse_entered()
	_pos_label.text = "x = " + str(_mouse_pos.x) + " y = " + str(_mouse_pos.y)

func item_from_colliding_body(colliding_body : StaticBody):
	if not colliding_body:
		return null
	var curr: Node = colliding_body
	while curr != null and not (curr is Wall or curr is OControl):
		curr = curr.get_parent()
	return curr
			
func handle_mouse_click_event(mouse_event:InputEventMouseButton):
	if mouse_event.is_action_pressed("left_click"):
		if state == EditorState.ADD_WALL_STATE:
			handle_add_wall_click(mouse_event)
		if state == EditorState.DELETE_STATE:
			handle_delete_click(mouse_event)
		if state == EditorState.ADD_CONTROL_STATE:
			handle_add_control_click(mouse_event)
		if state == EditorState.SET_START_STATE:
			handle_change_start_click(mouse_event)
		if state == EditorState.SET_GOAL_STATE:
			handle_change_goal_click(mouse_event)

func handle_change_start_click(_mouse_event:InputEventMouseButton):
	map_renderer.get_map().start_pos = _mouse_pos
	rerender_map()

func handle_change_goal_click(_mouse_event:InputEventMouseButton):
	map_renderer.get_map().goal_pos = _mouse_pos
	rerender_map()

func handle_delete_click(_mouse_event:InputEventMouseButton) -> void:
	var collider = _ray_cast.get_collider()
	if collider:
		var curr: Node = collider
		while curr != null and not (curr is Wall or curr is OControl):
			curr = curr.get_parent()
		if curr == null:
			return
		var item = curr
		if curr is Wall:
			var walls : Array = map_renderer.get_map().walls
			var wall = item as Wall
			walls.remove(wall.wall_index)
		if curr is OControl:
			var controls : Array = map_renderer.get_map().controlls
			var control = item as OControl
			controls.remove(control.control_index)
		rerender_map()	

func handle_add_wall_click(_mouse_event:InputEventMouseButton):
	if _click_one == Vector2.INF:
		_click_one = _mouse_pos
	else:
		map_renderer.get_map().add_wall(_click_one, _mouse_pos)
		_click_one = Vector2.INF
		rerender_map()

func handle_add_control_click(_mouse_event:InputEventMouseButton):
	map_renderer.get_map().add_control(_mouse_pos)
	rerender_map()

func rerender_map():
	entered_item = null
	var new_renderer = map_renderer_scene.instance()
	new_renderer.set_map(map_renderer.get_map())
	var old_renderer = map_renderer
	old_renderer.queue_free()
	map_renderer = new_renderer
	camera = map_renderer.get_node("Camera")
	viewport.add_child(new_renderer)
	map_renderer.get_map().connect("changed", self, "rerender_map")
	

func _on_SaveFileDialog_file_selected(path):
	map_renderer.get_map().update_hash()
	map_renderer.get_map().save(path)
	var save_dialog : FileDialog = find_node("SaveFileDialog")
	save_dialog.update()


func _on_OpenFileDialog_file_selected(path):
	SceneSwitcher.clear_params()
	var map_resource = load(path)
	if map_resource is MapResource:
		map_renderer.map = map_resource
		rerender_map()
	else:
		find_node("IncorrectMapFileDialog").popup()


func _on_ViewportCenterContainer_resized():
	viewport.size = viewport_center_container.rect_size
	viewport_container.rect_size = viewport_center_container.rect_size
	viewport_container.rect_min_size = viewport_center_container.rect_size
