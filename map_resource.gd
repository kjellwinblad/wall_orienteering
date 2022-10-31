extends Resource

class_name MapResource

export(float) var width = 100.0
export(float) var height = 100.0

export(Array, Array, Vector2) var walls = [[Vector2(20, 20), Vector2(80, 20)]]
export(Array, Vector2) var controlls = []

export(Vector2) var start_pos:Vector2 = Vector2(3,3)
export(Vector2) var goal_pos:Vector2 = Vector2(97,97)
export(String) var name : String = "New Map"
export(String) var hash_value : String = "not updated, should always be updated before a map is saved"

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
	var err = ResourceSaver.save(path, self)
	if err != OK:
		print("error ResourceSaver.save(path, self)")

func update_hash():
	var strings: PoolStringArray = PoolStringArray()
	strings.append(str(width))
	strings.append(str(height))
	for wall in walls:
		strings.append(str(wall[0]))
		strings.append(str(wall[1]))
	for control in controlls:
		strings.append(str(control[0]))
	strings.append(str(start_pos))
	strings.append(str(goal_pos))
	strings.append(name)
	var joined : String = strings.join(",")
	hash_value = joined.md5_text()
