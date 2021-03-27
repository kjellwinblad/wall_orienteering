extends Resource

class_name MapResource

export(float) var width = 100.0
export(float) var height = 100.0

export(Array, Array, Vector2) var walls = [[Vector2(20, 20), Vector2(80, 20)]]
export(Array, Vector2) var controlls = []

export(Vector2) var start_pos:Vector2 = Vector2(3,3)
export(Vector2) var goal_pos:Vector2 = Vector2(97,97)
export(String) var name : String = "New Map"

func _init():
	._init()
	walls = []
	controlls = []

func add_wall(from: Vector2, to: Vector2):
	walls.append([from, to])
	emit_signal("changed")

func add_control(pos: Vector2):
	controlls.append(pos)
	emit_signal("changed")

func save(path:String):
	print("Saveing", path)
	ResourceSaver.save(path, self)
