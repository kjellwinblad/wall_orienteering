extends Resource

class_name MapResource

export(float) var width = 100.0
export(float) var height = 100.0

export(Array, Array, Vector2) var walls = [[Vector2(0,0), Vector2(50,50)]]
export(Array, Vector2) var controlls = [Vector2(10,15), Vector2(10,5)]


func add_wall(from: Vector2, to: Vector2):
	walls.append([from, to])
	emit_signal("changed")

func add_control(pos: Vector2):
	controlls.append(pos)
	emit_signal("changed")

func save(path:String):
	print("Saveing", path)
	ResourceSaver.save(path, self)
