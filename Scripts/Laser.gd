extends StaticBody

onready var beam = $Beam
onready var colide_ray = $ColideRay
onready var harm_ray = $HarmRay
onready var particles = $Particles

func _physics_process(delta):
	var beam_lenght = (colide_ray.get_collision_point() - translation).length()
	
	beam.scale.y = beam_lenght
	particles.translation.y = beam_lenght
	
	harm_ray.cast_to.y = beam_lenght
	if harm_ray.is_colliding():
		var col = harm_ray.get_collider()
		if col.is_in_group("Bodies"):
			col.destroy()
		if col.is_in_group("Player"):
			var point = harm_ray.get_collision_point()
			var push = (col.translation + Vector3(0.0, point.y - col.translation.y, 0.0)) - point - col.velocity
			col.move_and_slide(push)
	

	
	
