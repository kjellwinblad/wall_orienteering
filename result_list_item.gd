extends VBoxContainer

class_name ResultListItem

export(int) var rank = 0
export(String) var result_name = "Kjell Winblad"
export(int) var time = 123234

func _ready():
	find_node("NumberLabel").text = str(rank) + "."
	find_node("NameLabel").text = result_name
	find_node("TimeLabel").text = str(HelperFuncs.elapsedTimeMicrosecondToTimeString(time))
