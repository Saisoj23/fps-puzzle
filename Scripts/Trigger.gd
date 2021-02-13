extends StaticBody

signal update_trigger

export (Colors.COLORS) var color

onready var mesh: = $Detector/Light
onready var ray: = $RayCast

var colliding: = false
var object: = RigidBody

func _ready():
	set_color()
	
	connect("update_trigger", get_parent(), "_update_door")

func set_color():
	add_to_group(Colors.COLORS.keys()[color])
	mesh.material_override = Colors.color_materials[color].duplicate()
	
func _process(delta):
	if ray.is_colliding():
		if colliding:
			if !ray.get_collider().is_in_group(Colors.COLORS.keys()[color]):
				colliding = false
				active(false)
				if object != null:
					object.light(false)
		else:
			if ray.get_collider().is_in_group(Colors.COLORS.keys()[color]):
				colliding = true
				active(true)
				object = ray.get_collider()
				object.light(true)
	elif colliding: 
		colliding = false
		active(false)
		if object != null:
					object.light(false)
			
			
func active(active: bool):
	if active:
		mesh.material_override.set_shader_param("Intensity", 1)
	else:
		mesh.material_override.set_shader_param("Intensity", 0)
	
	emit_signal("update_trigger")
	
	
