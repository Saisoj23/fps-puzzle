extends HoldableBody

onready var mesh_internal = $Mesh/Magnet

export (Colors.COLORS) var color

func _ready():
	set_color()

func set_color(value:= color):
	color = value
	add_to_group(Colors.COLORS.keys()[value])
	mesh.material_override = Colors.color_materials[value].duplicate()
	
func destroy():
	col.disabled = true
	gravity_scale = -0.1
	mesh.material_override = burn_material
	mesh_internal.material_override = burn_material
	tween.interpolate_property(mesh.material_override, "shader_param/Scalar", 
	1.0, 0.0, 2, Tween.TRANS_LINEAR)
	tween.interpolate_property(mesh_internal.material_override, "shader_param/Scalar", 
	1.0, 0.0, 2, Tween.TRANS_LINEAR)
	tween.start()
	yield(tween, "tween_all_completed")
	queue_free()

func light(active: bool):
	if active:
		tween.interpolate_property(mesh.material_override, "shader_param/Intensity", 
		0.0, 1.0, 0.5, Tween.TRANS_BOUNCE, Tween.EASE_IN)
		tween.start()
	else:
		tween.interpolate_property(mesh.material_override, "shader_param/Intensity", 
		1.0, 0.0, 0.5, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
		tween.start()


