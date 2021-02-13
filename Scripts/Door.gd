extends Spatial

var triggers: Array

onready var anim = $AnimationTree

var state_machine

func _ready():
	state_machine = anim["parameters/playback"]
	for child in get_children():
		if child.is_in_group("Trigger"): triggers.append(child)
		
func _update_door():
	var actives: = true
	for child in triggers:
		if child.colliding == false: actives = false
	
	if actives:
		state_machine.travel("Open")
	else:
		state_machine.travel("Closed")
