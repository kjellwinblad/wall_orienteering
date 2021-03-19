extends Spatial

class_name Wall

export(float) var length := 1.0 
onready var main_wall : MeshInstance = $MainWall
var wall_index: int = 42


func _ready():
	main_wall.mesh = main_wall.mesh.duplicate()
	var mesh : CubeMesh = main_wall.mesh
	mesh.size = Vector3(length, mesh.size.y, mesh.size.z)
	main_wall.create_trimesh_collision()
