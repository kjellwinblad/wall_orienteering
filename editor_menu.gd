extends MenuButton

class_name EditorMenu

signal id_pressed

var snap_to_meters = false

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
	SET_GOAL_MODE,
	TO_MAIN_MENU,
	SNAP_TO_METERS
}

func _ready():
	var popup : PopupMenu = get_popup()
	popup.add_item("Open...", MenuItemId.OPEN)
	popup.add_item("Save As...", MenuItemId.SAVE)
	popup.add_separator()
	popup.add_item("Properties...", MenuItemId.SET_GROUND_SIZE)
	popup.add_separator()
	popup.add_item("Set Start", MenuItemId.SET_START_MODE)
	popup.add_item("Set Goal", MenuItemId.SET_GOAL_MODE)
	popup.add_separator()
	popup.add_item("Add Wall Mode (Ctrl+W)", MenuItemId.ADD_WALL)
	popup.add_item("Add Control Mode (Ctrl+E)", MenuItemId.ADD_CONTROL)
	popup.add_separator()
	popup.add_item("Remove Mode (Ctrl+R)", MenuItemId.DELETE_MODE)
	popup.add_separator()
	popup.add_item("Clear All Walls", MenuItemId.CLEAR_WALLS)
	popup.add_item("Clear All Controls", MenuItemId.CLEAR_CONTROLS)
	popup.add_separator()
	popup.add_check_item("Snap to meters", MenuItemId.SNAP_TO_METERS)
	popup.set_item_checked(MenuItemId.SNAP_TO_METERS, snap_to_meters)
	popup.add_separator()
	popup.add_item("Exit to Main Menu", MenuItemId.TO_MAIN_MENU)
	var err = popup.connect("id_pressed", self, "_on_item_pressed")
	if err != OK:
		print("error popup.connect(id_pressed")

func _on_item_pressed(id):
	var popup : PopupMenu = get_popup()
	if id == MenuItemId.SNAP_TO_METERS:
		snap_to_meters = not snap_to_meters
		popup.set_item_checked(MenuItemId.SNAP_TO_METERS, snap_to_meters)
	else:
		emit_signal("id_pressed", id)

