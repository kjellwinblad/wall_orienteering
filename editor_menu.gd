extends MenuButton

class_name EditorMenu

signal id_pressed

enum MenuItemId {
	SAVE,
	OPEN,
	ADD_WALL,
	ADD_CONTROL,
	CLEAR_WALLS,
	CLEAR_CONTROLS,
	SELECT_MODE,
	DELETE_MODE,
	SET_GROUND_SIZE,
	SET_START_MODE,
	SET_GOAL_MODE
}

func _ready():
	var popup : PopupMenu = get_popup()
	popup.add_item("Open...", MenuItemId.OPEN)
	popup.add_item("Save As...", MenuItemId.SAVE)
	popup.add_item("Set Ground Size", MenuItemId.SET_GROUND_SIZE)
	popup.add_item("Set Start", MenuItemId.SET_START_MODE)
	popup.add_item("Set Goal", MenuItemId.SET_GOAL_MODE)
	popup.add_item("Select Mode", MenuItemId.SELECT_MODE)
	popup.add_item("Add Wall Mode", MenuItemId.ADD_WALL)
	popup.add_item("Add Control Mode", MenuItemId.ADD_CONTROL)
	popup.add_item("Delete Mode", MenuItemId.DELETE_MODE)
	popup.add_item("Clear All Walls", MenuItemId.CLEAR_WALLS)
	popup.add_item("Clear All Controls", MenuItemId.CLEAR_CONTROLS)
	popup.connect("id_pressed", self, "_on_item_pressed")

func _on_item_pressed(id):
	var popup : PopupMenu = get_popup()
	emit_signal("id_pressed", id)
	print(popup.get_item_text(id), " pressed", id)
