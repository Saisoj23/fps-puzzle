extends RigidBody
class_name HoldableBody

onready var mesh: = $Mesh
onready var tween: = $Tween
onready var col = $CollisionShape

var burn_material

const HOLD_SPEED = 20
const HOLD_ROTATION_SPEED = 10

var initial_angular_dump: float
var initial_rotation: Basis
var initial_weight: float

var target: Position3D setget set_target
var targetting: = false

func _init():
	burn_material = Colors.burn_material.duplicate()
	
func _ready():
	mesh.material_override = burn_material

func set_target (value: Position3D):
	target = value
	
	if (target != null): 
		self.targetting = true
		self.initial_angular_dump = self.angular_damp
		self.initial_weight = self.weight
		self.weight = initial_weight / 4
		self.gravity_scale = 0
#		self.continuous_cd = true
		
		var a = target.global_transform.origin
		var b = self.global_transform.origin
		self.set_linear_velocity((a-b)*HOLD_SPEED)
		
		custom_behavior(true)
	else: 
		self.weight = self.initial_weight
		self.targetting = false
		self.gravity_scale = 1
#		self.continuous_cd = false
		
		custom_behavior(false)
		
func destroy():
	set_target(null)
	linear_damp = 5
	col.disabled = true
	gravity_scale = -0.1
	mesh.material_override = burn_material
	tween.interpolate_property(mesh.material_override, "shader_param/Scalar", 
	1.0, 0.0, 1, Tween.TRANS_LINEAR)
	tween.start()
	yield(tween, "tween_completed")
	queue_free()
		
func custom_behavior (active: bool):
	pass
	
func  _integrate_forces (state):
	if targetting:
		var a = target.global_transform.origin
		var b = self.global_transform.origin
		var c = a - b
		
		var aa = target.global_transform.basis.get_rotation_quat()
		var bb = self.global_transform.basis.get_rotation_quat()
		var cc = (aa * bb.inverse()).get_euler()
		
		if (state.get_contact_count() != 0):
			state.add_central_force(c * 5)
			state.linear_velocity = clamp_vector(state.linear_velocity, 5)
			
			state.add_torque(c * 10)
			state.angular_velocity = clamp_vector(state.angular_velocity, 5)
	
		else:
			state.linear_velocity = c * HOLD_SPEED
			state.angular_velocity = cc * HOLD_ROTATION_SPEED
		
		
func clamp_vector(value: Vector3, clamp_value: float) -> Vector3:
	value.x = clamp(value.x, -clamp_value, clamp_value)
	value.y = clamp(value.y, -clamp_value, clamp_value)
	value.z = clamp(value.z, -clamp_value, clamp_value)
	return value
	

