extends CharacterBody3D

var mouse_sensitivity = 0.001
const SPEED = 5.0

func _input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		$Camera3D.rotate_x(-event.relative.y * mouse_sensitivity)
		$Camera3D.rotation.x = clampf($Camera3D.rotation.x, -deg_to_rad(70), deg_to_rad(70))
	if event.is_action_pressed("alt"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(_delta):
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
	
	if Input.is_action_just_pressed("Engage_Park"):
		Globals.park_engaging = true
		print("engaging park")
	
	if Input.is_action_just_pressed("buckle_toggle") and Globals.buckled == false:
		Globals.buckled = true
		print("we are buckled")
	elif Input.is_action_just_pressed("buckle_toggle") and Globals.buckled == true and Globals.safe_unbuckle == true:
		Globals.buckled = false
		print("we are unbuckled")

	var input_dir = Input.get_vector("A", "D", "W", "S")
	var direction = (self.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction and Globals.buckled == false:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	move_and_slide()
