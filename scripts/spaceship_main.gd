extends CharacterBody3D

@onready var front_camera: Camera3D = $"Cockpit/Monitors/Front Camera/SubViewport/Front_camera"


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var Forward_acceleration = 10.0
var Forward_deceleration = 0.1

var rotation_speed = 0.05
var unrotation_speed = 0.001
var rotation_velocity_z = 0
var rotation_velocity_y = 0
var rotation_velocity_x = 0

var rot_brake = false
var thrust_brake = false

func _physics_process(delta: float) -> void:
	
	if self.rotation.x > 0 or self.rotation.z > 0 or self.rotation.x < 0 or self.rotation.z < 0 or self.rotation.y < 0 or self.rotation.y < 0:
		Globals.safe_unbuckle = false
	else:
		Globals.safe_unbuckle = true
	
	if Input.is_action_just_pressed("Engage_Park"):
		Globals.park_engaging = true
	
	#brake toggles
	if Input.is_action_just_pressed("Zero_Rotation_Toggle"):
		if rot_brake == true:
			rot_brake = false
			print("Rotation unlocked")
		else:
			rot_brake = true
			print("Rotation brake active")
			
	if Input.is_action_just_pressed("Thrust_Brake_Toggle"):
		if thrust_brake == true:
			thrust_brake = false
			print("Glide enabled")
		else:
			thrust_brake = true
			print("Thrust brake active")

	#movement
	if Input.is_action_pressed("Thrust_Up") and !Globals.park_engaging and Globals.buckled:
		var thrust_force = transform.basis.z * Forward_acceleration * delta
		velocity += thrust_force
	if Input.is_action_pressed("Thrust_Down") and !Globals.park_engaging and Globals.buckled:
		var reverse_force = -transform.basis.z * Forward_acceleration * delta
		velocity += reverse_force

	#rotations
	if Input.is_action_pressed("Rotate_Roll_Left") and !Globals.park_engaging and Globals.buckled:  # Roll left
		rotation_velocity_z -= rotation_speed * delta
	elif Input.is_action_pressed("Rotate_Roll_Right") and !Globals.park_engaging and Globals.buckled:  # Roll right
		rotation_velocity_z += rotation_speed * delta
	rotate_z(rotation_velocity_z)
	
	if Input.is_action_pressed("Rotate_Yaw_Left") and !Globals.park_engaging and Globals.buckled:  # Roll left
		rotation_velocity_y -= rotation_speed * delta
	elif Input.is_action_pressed("Rotate_Yaw_Right") and !Globals.park_engaging and Globals.buckled:  # Roll right
		rotation_velocity_y += rotation_speed * delta
	rotate_y(rotation_velocity_y)

	if Input.is_action_pressed("Rotate_Pitch_Down") and !Globals.park_engaging and Globals.buckled:  # Roll left
		rotation_velocity_x -= rotation_speed * delta
	elif Input.is_action_pressed("Rotate_Pitch_Up") and !Globals.park_engaging and Globals.buckled:  # Roll right
		rotation_velocity_x += rotation_speed * delta
	rotate_x(rotation_velocity_x)
	
	#brakes
	if rot_brake:
		rotation_velocity_x = move_toward(rotation_velocity_x, 0.0, unrotation_speed)
		rotation_velocity_y = move_toward(rotation_velocity_y, 0.0, unrotation_speed)
		rotation_velocity_z = move_toward(rotation_velocity_z, 0.0, unrotation_speed)
	if thrust_brake:
		velocity.x = move_toward(velocity.x, 0.0, Forward_deceleration)
		velocity.y = move_toward(velocity.y, 0.0, Forward_deceleration)
		velocity.z = move_toward(velocity.z, 0.0, Forward_deceleration)
	
	if Globals.park_engaging == true:
		print("ship is parking")
		park_ship()
	
	stick_camera()
	
	move_and_slide()

func park_ship():
		# Smoothly interpolate the rotation toward the target
		rotation.x = lerp_angle(rotation.x, 0.0, rotation_speed / 2)
		rotation.y = lerp_angle(rotation.y, 0.0, rotation_speed / 2)
		rotation.z = lerp_angle(rotation.z, 0.0, rotation_speed / 2)
		
		# Stop parking when close enough to zero rotation
		if rotation.x == 0 and rotation.y == 0 and rotation.z == 0:
			Globals.park_engaging = false
			print("ship has parked")

		await get_tree().create_timer(5.0).timeout
		rotation = Vector3(0, 0, 0)

func stick_camera():
	front_camera.position = self.position
	front_camera.position.y = self.position.y + 1.6
	front_camera.position.z = self.position.z + 3
	
	front_camera.global_rotation_degrees = -self.global_rotation_degrees
	front_camera.global_rotation_degrees.y = self.global_rotation_degrees.y + 180
