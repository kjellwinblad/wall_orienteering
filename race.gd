extends Spatial

enum GameState {
	SHOW_MAP,
	NORMAL
}
var state = GameState.NORMAL

func _ready():
	$PlayerHolder/Player/Camera2.current = true
	var start : Vector2 = $MapRenderer.get_map().start_pos
	$PlayerHolder.translation = (Vector3(start.x, 0, start.y))


func _input(event):
	if event.is_action_pressed("show_map"):
		$MapRenderer/Camera.current = true
		$PlayerHolder/Player.visible = false
	if event.is_action_released("show_map"):
		$PlayerHolder/Player/Camera2.current = true
