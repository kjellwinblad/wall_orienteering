extends CanvasLayer


onready var map_editor_scene = preload("res://MapEditor.tscn")


func _on_PlayButton_pressed():
	self.queue_free()
	get_tree().change_scene("res://Race.tscn")


func _on_CreateNewMapButton_pressed():
	self.queue_free()
	get_tree().change_scene("res://MapEditor.tscn")
	var r: Viewport = get_tree().root


func _on_ExitButton_pressed():
	get_tree().quit()
