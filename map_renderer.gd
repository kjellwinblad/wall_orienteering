extends Spatial

class_name MapRenderer

signal player_hit_goal
signal player_hit_control

export(Resource) onready var map = map as MapResource
export(Resource) onready var run_path = run_path as RacePathResouce


onready var _floor : MeshInstance = find_node("Floor")
onready var wall_scene = preload("res://Wall.tscn")
onready var control_scene = preload("res://Control.tscn")
onready var start_scene = preload("res://Start.tscn")
onready var goal_scene = preload("res://Goal.tscn")
onready var _world_nodes = $WorldNodes
onready var ig:ImmediateGeometry = find_node("ImmediateGeometry")



func set_map(init_map: MapResource):
	map = init_map

func _ready():
	if SceneSwitcher.get_param("race_path"):
		run_path = SceneSwitcher.get_param("race_path")
	if SceneSwitcher.get_param("map"):
		map = SceneSwitcher.get_param("map")
	create_world()

func get_map() -> MapResource:
	return map

func _process(_delta):
	render_race_path()
	
func render_race_path():
	if run_path == null:
		return
	ig.clear()
	ig.begin(Mesh.PRIMITIVE_LINE_STRIP)
	ig.set_color(Color.red)
	for pos in run_path.points:
		pos = pos as Vector2
		ig.add_vertex(Vector3(pos.x,3, pos.y))
	ig.end()
	

func create_world() -> void:
	var floor_mesh : CubeMesh = _floor.mesh
	floor_mesh.size.x = map.width
	floor_mesh.size.y = map.height
	_floor.translate(Vector3(map.width/2, -map.height/2, 0))
	_floor.create_trimesh_collision()
	var wall_maker_width : float = max(0.1, max(map.width, map.height)/200)
	var control_marker_with : float = max(0.1, max(map.width, map.height)/20)
	var index := 0
	for wall_cords in map.walls:
		var start: Vector2 = wall_cords[0]
		var end: Vector2 = wall_cords[1]	
		var wall: Wall = wall_scene.instance()
		var wall_length = (wall_cords[0] - wall_cords[1]).length()
		wall.length = wall_length
		wall.marker_width = wall_maker_width
		wall.look_at_from_position(Vector3(start.x,0, start.y),Vector3(end.x,0, end.y), Vector3.UP)
		wall.translate_object_local(Vector3(0,0,-wall_length/2))
		wall.wall_index = index
		index += 1
		add_child(wall)
	index = 0
	for control_point in map.controlls:
		control_point = control_point as Vector2
		var control:OControl  = control_scene.instance()
		control.size_on_map = control_marker_with
		control.transform.origin = Vector3(control_point.x,0, control_point.y)
		control.control_index = index
		index += 1
		var err = control.connect("player_hit_control", self, "player_hit_control")
		if err != OK:
			print("error control.connect(player_hit_control")
		add_child(control)
	var goal = goal_scene.instance()
	goal.transform.origin = Vector3(map.goal_pos.x,0, map.goal_pos.y)
	goal.connect("entered", self, "player_entered_goal")
	add_child(goal)
	var start = start_scene.instance()
	start.transform.origin = Vector3(map.start_pos.x,0, map.start_pos.y)
	add_child(start)
	var camera : Camera = $Camera
	camera.size = max(map.width, map.height)
	camera.translate(Vector3(map.width/2, -map.height/2, 0))

func player_hit_control(index: int):
	emit_signal("player_hit_control", index)

func player_entered_goal():
	emit_signal("player_hit_goal")
