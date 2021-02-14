extends CanvasLayer

var post = preload("res://Materials/Enviroment.tres")

onready var enviroment = $WorldEnvironment

func _on_CheckBox_toggled(button_pressed):
	if button_pressed:
		enviroment.environment = post
	else:
		enviroment.environment = null
