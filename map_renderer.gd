extends Spatial

class_name MapRenderer

export(Resource) onready var map = map as MapResource

onready var _floor : MeshInstance = $WorldNodes/Floor
onready var wall_scene = preload("res://Wall.tscn")
onready var control_scene = preload("res://Control.tscn")
onready var _world_nodes = $WorldNodes

func set_map(init_map: MapResource):
	map = init_map

func _ready():
	create_world()

func get_map() -> MapResource:
	return map
	
func create_world() -> void:
	var floor_mesh : CubeMesh = _floor.mesh
	floor_mesh.size.x = map.width
	floor_mesh.size.y = map.height
	#_floor.create_trimesh_collision()
	_floor.translate(Vector3(map.width/2, -map.height/2, 0))
	print(floor_mesh.size.y)
	var index := 0
	for wall_cords in map.walls:
		var start: Vector2 = wall_cords[0]
		var end: Vector2 = wall_cords[1]	
		var wall: Wall = wall_scene.instance()
		var wall_length = (wall_cords[0] - wall_cords[1]).length()
		wall.length = wall_length
		var angle = (start-end).angle_to(Vector2.RIGHT)
		#wall.global_transform.origin = Vector3(start.x,0,start.y)
		wall.look_at_from_position(Vector3(start.x,0, start.y),Vector3(end.x,0, end.y), Vector3.UP)
		wall.translate_object_local(Vector3(0,0,-wall_length/2))
		#wall.translate(Vector3(wall_length / 2,0,0))
		#wall.translate(Vector3(-wall_cords[0].x,0,-wall_cords[0].y))
		wall.wall_index = index
		index += 1
		add_child(wall)
		print(wall is Wall, wall.name)
	index = 0
	for control_point in map.controlls:
		control_point = control_point as Vector2
		var control:OControl  = control_scene.instance()
		control.transform.origin = Vector3(control_point.x,0, control_point.y)
		control.control_index = index
		index += 1
		add_child(control)
	var camera : Camera = $Camera
	camera.size = max(map.width, map.height)
	camera.translate(Vector3(map.width/2, -map.height/2, 0))

