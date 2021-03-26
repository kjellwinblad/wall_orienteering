extends Spatial

class_name OControl

signal player_hit_control

export(float) var size_on_map = 1.0

var control_material: Material = null

var control_index = 42

onready var marker : MeshInstance = $MapFace

onready var beep_player: AudioStreamPlayer = $BeepAudioStreamPlayer

var mouse_hover_material = preload("res://purple_material.tres")

func _ready():
	var map_face : PlaneMesh = marker.mesh
	control_material = map_face.material
	map_face.size = Vector2(size_on_map, size_on_map)
	marker.create_trimesh_collision()
	var marker_static_body : StaticBody = marker.get_child(0)
	marker_static_body.connect("mouse_entered", self, "_mouse_entered")
	marker_static_body.connect("mouse_exited", self, "_mouse_exited")

func _mouse_entered():
	marker.material_override = mouse_hover_material

func _mouse_exited():
	marker.material_override = control_material


func _on_Area_body_entered(body):
	find_node("MapFaceTaken").visible = true
	emit_signal("player_hit_control", control_index)
	beep_player.play()
