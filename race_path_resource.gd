extends Resource

class_name RacePathResouce

export(Array, Vector2) var points = [Vector2(0,0)]

export(Array, int) var times = []

func _init():
	points.clear()
	times.clear()
	.init()

func add_point(time: int, location: Vector2):
	points.append(location)
	times.append(time)
