extends Spatial



enum EditorState {
	SELECT_STATE,
	ADD_WALL_STATE,
	DELETE_STATE,
	ADD_CONTROL_STATE
}

var state = EditorState.ADD_WALL_STATE
var _mouse_pos := Vector2()
var _click_one := Vector2.INF
onready var _ray_cast : RayCast = $MeshInstance/RayCast
onready var _pos_label = $CanvasLayer/PosLabel
onready var map_renderer : MapRenderer = $MapRenderer
onready var camera : Camera = $MapRenderer/Camera
onready var map_renderer_scene = preload("map_renderer.tscn")
onready var editor_menu : EditorMenu = $CanvasLayer/EditorMenu

func _ready():
	editor_menu.connect("id_pressed", self, "_on_menu_select")
	editor_menu.connect("mouse_entered", self, "_on_menu_entered")

func _on_menu_select(id):
	if id == editor_menu.MenuItemId.ADD_WALL:
		state = EditorState.ADD_WALL_STATE
	if id == editor_menu.MenuItemId.ADD_WALL:
		state = EditorState.ADD_WALL_STATE
	if id == editor_menu.MenuItemId.SELECT_MODE:
		state = EditorState.SELECT_STATE
	if id == editor_menu.MenuItemId.DELETE_MODE:
		state = EditorState.DELETE_STATE
	if id == editor_menu.MenuItemId.ADD_CONTROL:
		state = EditorState.ADD_CONTROL_STATE
	if id == editor_menu.MenuItemId.CLEAR_WALLS:
		map_renderer.get_map().walls = []
		rerender_map()
	if id == editor_menu.MenuItemId.CLEAR_CONTROLS:
		map_renderer.get_map().controlls = []
		rerender_map()
	if id == editor_menu.MenuItemId.SAVE:
		$SaveFileDialog.popup()
		$SaveFileDialog.invalidate()
	if id == editor_menu.MenuItemId.OPEN:
		$OpenFileDialog.popup()
		$OpenFileDialog.invalidate()

func _on_menu_entered():
	state = EditorState.SELECT_STATE

func _on_add_wall_pressed():
	state = EditorState.ADD_WALL_STATE

func _input(event):
	var mouse_motion_event = event as InputEventMouseMotion
	var mouse_click_event = event as InputEventMouseButton
	if mouse_motion_event:
		handle_mouse_motion_event(mouse_motion_event)
	if mouse_click_event:
		handle_mouse_click_event(mouse_click_event)

func handle_mouse_motion_event(mouse_event:InputEventMouseMotion):
	var dropPlane  = Plane(Vector3(0,0,0), Vector3(10,0,0), Vector3(10,0,10))
	var mousePosition3D = dropPlane.intersects_ray(
							 camera.project_ray_origin(mouse_event.position),
							 camera.project_ray_normal(mouse_event.position))
	_mouse_pos = Vector2(mousePosition3D.x, mousePosition3D.z)
	$MeshInstance.transform.origin = mousePosition3D
	#_ray_cast.enabled = true
	#_ray_cast.transform.origin = camera.project_ray_origin(mouse_event.position)
	#_ray_cast.look_at_from_position(camera.project_ray_origin(mouse_event.position), mousePosition3D, Vector3.UP)
	
	#_ray_cast.cast_to = mousePosition3D
	_pos_label.text = "x = " + str(_mouse_pos.x) + " y = " + str(_mouse_pos.y) + " is colid" + str(_ray_cast.is_colliding())

func handle_mouse_click_event(mouse_event:InputEventMouseButton):
	if mouse_event.is_action_pressed("left_click"):
		if state == EditorState.ADD_WALL_STATE:
			handle_add_wall_click(mouse_event)
		if state == EditorState.DELETE_STATE:
			handle_delete_click(mouse_event)
		if state == EditorState.ADD_CONTROL_STATE:
			handle_add_control_click(mouse_event)

func handle_delete_click(mouse_event:InputEventMouseButton) -> void:
	var collider= _ray_cast.get_collider()
	print("colider", collider)
	if collider:
		var curr: Node = collider
		while curr != null and not (curr is Wall or curr is OControl):
			print(curr.get_class())
			curr = curr.get_parent()
		print(curr, curr is OControl)
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
		


func handle_add_wall_click(mouse_event:InputEventMouseButton):
	if _click_one == Vector2.INF:
		_click_one = _mouse_pos
	else:
		map_renderer.get_map().add_wall(_click_one, _mouse_pos)
		_click_one = Vector2.INF
		rerender_map()

func handle_add_control_click(mouse_event:InputEventMouseButton):
	map_renderer.get_map().add_control(_mouse_pos)
	rerender_map()

func rerender_map():
	var new_renderer = map_renderer_scene.instance()
	new_renderer.set_map(map_renderer.get_map())
	var old_renderer = map_renderer
	old_renderer.queue_free()
	map_renderer = new_renderer
	camera = map_renderer.get_node("Camera")
	add_child(new_renderer)


func _on_SaveFileDialog_file_selected(path):
	map_renderer.get_map().save(path)
	var save_dialog : FileDialog = $SaveFileDialog
	save_dialog.update()


func _on_OpenFileDialog_file_selected(path):
	map_renderer.map = MapResource.new()
	print(path)
	map_renderer.map = load(path)
	rerender_map()
