extends WindowDialog

class_name SetSizeDialog

var map : MapResource = null

func _ready():
	pass # Replace with function body.

func popup_with_map(map_p:MapResource):
	map = map_p
	find_node("HeightLineEdit").text = str(map.height)
	find_node("WidthLineEdit").text = str(map.width)
	popup()

func _on_CancelButton_pressed():
	hide()


func _on_SaveButton_pressed():
	var height_str = find_node("HeightLineEdit").text
	var width_str = find_node("WidthLineEdit").text
	if not height_str.is_valid_float() or float(height_str) < 1:
		$BadHeightDialog.popup()
		return
	if not width_str.is_valid_float() or float(width_str) < 1:
		$BadWidthDialog.popup()
		return
	map.height = float(height_str)
	map.width = float(width_str)
	map.emit_signal("changed")
	hide()
