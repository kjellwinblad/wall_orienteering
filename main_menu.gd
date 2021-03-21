extends CanvasLayer


onready var map_editor_scene = preload("res://MapEditor.tscn")

func _ready():
	get_viewport().connect("size_changed", self, "on_size_changed")


func _on_PlayButton_pressed():
	self.queue_free()
	get_tree().change_scene("res://SelectPracticeMap.tscn")


func _on_CreateNewMapButton_pressed():
	self.queue_free()
	SceneSwitcher.change_scene("res://MapEditor.tscn", {"map": MapResource.new()})


func _on_ExitButton_pressed():
	get_tree().quit()

func on_size_changed(object):
	print("changed size", object)
