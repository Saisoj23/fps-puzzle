extends Spatial

signal pressed

export (Colors.COLORS) var color

onready var button = $Button
onready var mesh = $Button/Button
onready var tween = $Tween
onready var timer = $Timer
onready var position0 = $Position0
onready var position1 = $Position1

var is_pressing: = false

func _ready():
	connect("pressed", get_parent(), "_dispense_cube")
	set_color()
	
func set_color():
	add_to_group(Colors.COLORS.keys()[color])
	mesh.material_override = Colors.color_materials[color].duplicate()

func press():
	if !is_pressing:
		pressing()

func pressing():
	is_pressing = true
	emit_signal("pressed")
	tween.interpolate_property(button, "translation", 
	position0.translation, position1.translation, 
	0.2, Tween.TRANS_BOUNCE, Tween.EASE_IN)
	tween.start()
	yield(tween, "tween_completed")
	
	tween.interpolate_property(button, "translation", 
	position1.translation, position0.translation, 
	0.2, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	tween.start()
	timer.start(2.0)
	yield(timer, "timeout")
	
	is_pressing = false
