extends Spatial

signal entered

func _ready():
	pass


func _on_Area_body_entered(body):
	emit_signal("entered")
