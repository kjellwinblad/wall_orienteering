extends Node

func elapsedTimeMicrosecondToTimeString(time:int) -> String:
	# warning-ignore:integer_division
	time = time / 100
	var milliseconds := time % 10
	# warning-ignore:integer_division
	time = time / 10
	var seconds := time % 60
	# warning-ignore:integer_division
	time = time / 60
	var minutes := time
	return str(minutes).pad_zeros(2) + ":" + str(seconds).pad_zeros(2) + ":" + str(milliseconds)
