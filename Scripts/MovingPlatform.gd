extends KinematicBody

export var SPEED: float

var positions = []
var target: Vector3
var position_index: = 0

func _ready():
	for i in get_children():
		if i is Position3D:
			positions.append(i.global_transform.origin)
			i.queue_free()
	
	target = positions[0]
			
func _physics_process(delta):
	if (global_transform.origin != target):
		var velocity = global_transform.origin.direction_to(target)
		move_and_collide(velocity * SPEED * delta)
		if (global_transform.origin - target).length() < 0.2:
			global_transform.origin = target
		
		for index in get_slide_count():
			var collision = get_slide_collision(index)
			if collision.collider.is_in_group("Bodies"):
				collision.collider.apply_central_impulse(-collision.normal)
	
	else:
		position_index += 1
		if position_index >= positions.size(): position_index = 0
		target = positions[position_index]
		
			
