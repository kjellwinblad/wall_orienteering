extends Spatial

class_name Wall

export(float) var length := 1.0
export(float) var marker_width := 1.0
onready var main_wall : MeshInstance = $MainWall
onready var wall_marker : MeshInstance = $WallMarker
var wall_index: int = 42

var mouse_hover_material = preload("res://purple_material.tres")
var normal_show_material = preload("res://black_material.tres")


func _ready():
	main_wall.mesh = main_wall.mesh.duplicate()
	var mesh : CubeMesh = main_wall.mesh
	mesh.size = Vector3(length, mesh.size.y, mesh.size.z)
	wall_marker.mesh = wall_marker.mesh.duplicate()
	var marker_mesh: PlaneMesh = wall_marker.mesh
	marker_mesh.size.y = length
	marker_mesh.size.x = marker_width
	main_wall.create_trimesh_collision()
	wall_marker.create_trimesh_collision()
	var marker_static_body : StaticBody = wall_marker.get_child(0)
	marker_static_body.connect("mouse_entered", self, "_mouse_entered")
	marker_static_body.connect("mouse_exited", self, "_mouse_exited")
	wall_marker.material_override = normal_show_material

func _mouse_entered():
	wall_marker.material_override = mouse_hover_material


func _mouse_exited():
	wall_marker.material_override = normal_show_material
