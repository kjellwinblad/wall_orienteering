extends CenterContainer

var map : MapResource = null setget set_map
onready var button : Button = $Button

func _ready():
	if map:
		button.text = map.name
	# warning-ignore:return_value_discarded
	button.connect("pressed", self, "load_map")

func load_map():
	SceneSwitcher.change_scene("res://PracticeIntro.tscn", {"map": map})

func set_map(map_parm: MapResource):
	map = map_parm
