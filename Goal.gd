extends Spatial

signal entered

func _ready():
	pass


func _on_Area_body_entered(_body):
	emit_signal("entered")
