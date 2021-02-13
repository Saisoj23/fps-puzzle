extends KinematicBody

export var SPEED: float
export var ACELERATION: float
export var GRAVITY: float
export var SNAP_DISTANCE: float
export var JUMP_FORCE: float
export var AIR_CONTROL: float
export var THROW_SPEED: float

export var SENSIBILITY: float

var direction: = Vector3()
var velocity: = Vector3()
var fall: = Vector3()
var grounded: = false
var snap: = Vector3()
var is_snaping: = false
var is_holding: = false

var object_holding: RigidBody
var object_angular_damp: float
var object_rotation: Vector3

onready var head = $Head
onready var ground_check = $GroundCheck
onready var hold_position = $Head/Camera/Object
onready var eye = $Head/Camera/Seek

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta): 
	#enter/exit game
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	elif Input.is_action_just_pressed("ui_accept"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	#movement
	direction = get_direction()
	
	grounded = get_grounded()
	
	velocity = get_movement_and_jump(velocity)
		
	snap = -get_floor_normal() * SNAP_DISTANCE if is_snaping else Vector3.ZERO
	
	velocity = move_and_slide_with_snap(velocity, snap, Vector3.UP, true, 4, 0.78, false)
	
	apply_collitions()
			
	#hold objects
	holding_check()
				
	
func _input(event):
	#move camera
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * SENSIBILITY))
		head.rotate_x(deg2rad(-event.relative.y * SENSIBILITY))
		head.rotation.x = clamp(head.rotation.x, deg2rad(-90), deg2rad(90))


func get_direction() -> Vector3:
	var out: Vector3
	out += (Input.get_action_strength("move_right")
	- Input.get_action_strength("move_left")) * transform.basis.x
	out += (Input.get_action_strength("move_backwards")
	- Input.get_action_strength("move_foward")) * transform.basis.z
	return out.normalized()
	
func get_grounded() -> bool:
	if is_on_floor() || ground_check.is_colliding(): 
		return true
	else: return false
	
func get_movement_and_jump(out: Vector3) -> Vector3:
	if grounded:
		out = out.linear_interpolate(direction * SPEED, ACELERATION * get_physics_process_delta_time())
		if !is_snaping: is_snaping = true
	if !grounded:
		out = out.linear_interpolate(direction * SPEED, ACELERATION * AIR_CONTROL * get_physics_process_delta_time())
		if is_snaping: is_snaping = false
		
	if out.length() < 0.05: velocity = Vector3()
		
	if Input.is_action_just_pressed("jump") && grounded:
		is_snaping = false
		out += Vector3.UP * JUMP_FORCE
	elif !grounded:
		out += GRAVITY * Vector3.DOWN
	
	return out
	
func apply_collitions():
	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision.collider.is_in_group("Bodies"):
			collision.collider.apply_central_impulse(-collision.normal)
			
func holding_check():
	if Input.is_action_just_pressed("fire1"):
		if is_holding:
			if object_holding != null:
				object_holding.set_target(null)
			is_holding = false
			hold_position.rotation = Vector3.ZERO
			object_holding = null
		elif !is_holding && eye.is_colliding():
			var object = eye.get_collider()
			if object.is_in_group("Bodies"):
				is_holding = true
				object_holding = object
				object_holding.target = hold_position
				hold_position.global_transform.basis = object_holding.global_transform.basis
			elif object.is_in_group("Button"):
				object.get_parent().press()
				
	if Input.is_action_just_pressed("fire2"):
		if is_holding && object_holding != null:
			object_holding.target = null
			var a = head.global_transform.origin
			var b = object_holding.global_transform.origin
			object_holding.linear_velocity = (b-a)*THROW_SPEED
			is_holding = false
			
		
	if is_holding:
		if object_holding != null:
			pass
		else:
			is_holding = false
		if eye.is_colliding():
			if !(eye.get_collider().is_in_group("Bodies")): 
				is_holding = false
				hold_position.rotation = Vector3.ZERO
				object_holding.target = null
