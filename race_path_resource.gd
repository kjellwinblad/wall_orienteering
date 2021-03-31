extends Resource

class_name RacePathResouce

export(Array, Vector2) var points = [Vector2(0,0)]

export(Array, int) var times = []

func _init():
	points.clear()
	times.clear()
	._init()

func add_point(time: float, location: Vector2):
	points.append(location)
	times.append(time)


func to_json_string():
	var json_points = []
	for v in points:
		json_points.append(v.x)
		json_points.append(v.y)
	return JSON.print({"points": json_points, "times": times}, "", true)

func from_json_string(string):
	points = []
	times = []
	var res = JSON.parse(string)
	var object = res.result
	var prevP = null
	var i = 0
	for p in object["points"]:
		if prevP == null:
			prevP = p
		else:
			add_point(object["times"][i], Vector2(prevP, p))
			prevP = null
			i += 1
