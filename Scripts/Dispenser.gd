extends StaticBody

onready var trap_mesh = $Tube/TrapDoor
onready var trap_col = $TrapDoor
onready var tween = $Tween
onready var timer = $Timer
onready var spawn = $Position3D

export (Colors.COLORS) var color

var is_dispensing = false

var cube_scene = preload("res://SRC/Conductor.tscn")

var active
var capsuled

func _ready():
	spawn()
	
func _dispense_cube():
	if !is_dispensing:
		dispensing()
		
func dispensing():
	is_dispensing = true
	if active != null:
		active.destroy()
	tween.interpolate_property(trap_mesh, "blend_shapes/Open", 
	0.0, 1.0, 0.5, Tween.TRANS_CUBIC, Tween.EASE_IN)
	tween.start()
	yield(tween, "tween_completed")
	
	trap_col.disabled = true
	capsuled.linear_velocity.y += 0.1
	timer.start(1.0)
	yield(timer, "timeout")
	
	trap_col.disabled = false
	tween.interpolate_property(trap_mesh, "blend_shapes/Open", 
	1.0, 0.0, 0.5, Tween.TRANS_CUBIC, Tween.EASE_IN)
	tween.start()
	yield(tween, "tween_completed")
	
	active = capsuled
	spawn()
	
	is_dispensing = false
	
func spawn():
	capsuled = cube_scene.instance()
	capsuled.color = color
	add_child(capsuled)
	capsuled.global_transform.origin = spawn.global_transform.origin
