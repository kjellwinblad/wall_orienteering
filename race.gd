extends Spatial

onready var map_renderer_scene = preload("map_renderer.tscn")
onready var info_label : Label = find_node("InfoLabel")
onready var start_time : int = OS.get_system_time_msecs()
onready var time_label : Label = find_node("TimeLabel")
var controls = []
var route: RacePathResouce = RacePathResouce.new()
var player: Node = find_node("Player")

enum GameState {
	SHOW_MAP,
	NORMAL
}
var state = GameState.NORMAL

func _ready():
	if SceneSwitcher._params["map"] != null:
		load_map(SceneSwitcher._params["map"])
	else:
		load_map(MapResource.new())
	var map_render : MapRenderer = $MapRenderer
	for c in map_render.get_map().controlls:
		controls.append(false)
	$PlayerHolder/Player/Camera2.current = true
	var start : Vector2 = map_render.get_map().start_pos
	map_render.connect("player_hit_control", self, "punched_control")
	map_render.connect("player_hit_goal", self, "entered_goal")
	$PlayerHolder.translation = (Vector3(start.x, 0, start.y))

func all_controls_taken() -> bool:
	for c in controls:
		if not c:
			return false
	return true


func _input(event):
	if event.is_action_pressed("show_map"):
		$MapRenderer/Camera.current = true
		$PlayerHolder/Player.visible = false
		info_label.visible = false
	if event.is_action_released("show_map"):
		$PlayerHolder/Player/Camera2.current = true


func entered_goal():
	if all_controls_taken():
		info_label.visible = true
		info_label.text = "All Controls Taken!"
		SceneSwitcher.change_scene("res://PracticeCompleted.tscn", {"time": elapsed_time()})
	else:
		info_label.text = "You have not taken all controls!\n(Press space to see which one you have missed)"
		info_label.visible = true
		yield(get_tree().create_timer(10), "timeout")
		info_label.visible = false

func punched_control(index):
	controls[index] = true

func load_map(map):
	var new_renderer = map_renderer_scene.instance()
	new_renderer.set_map(map)
	add_child(new_renderer)

func elapsed_time() -> int:
	return (OS.get_system_time_msecs() - start_time)

func _on_Timer_timeout():
	var time := elapsed_time()
	time_label.text = HelperFuncs.elapsedTimeMicrosecondToTimeString(time)
	


func _on_StorePathTimer_timeout():
	route.add_point(elapsed_time(), player.global_transform.origin)
