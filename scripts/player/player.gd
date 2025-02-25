extends IKCC

@onready var camera : PhantomCamera3D = $PhantomCamera3D

@onready var model : Node3D = $Model

# character controller consts
const GROUND_SPEED : float = 3.8
const GROUND_SMOOTHING : float = 30

const ROTATE_SPEED : float = 0.15

# player movement states
var current_state : PlayerState

@onready var grounded_state : PlayerState = $GroundedState

var cam_rot : Vector3

@export var lockon_target : Node
var lockon :bool = false
const lockon_distance = 50

func _ready() -> void:

	current_state = grounded_state
	current_state.on_enter(self)
	
	if camera.rotation != self.global_rotation:
		cam_rot = self.global_rotation_degrees
		camera.set_third_person_rotation_degrees(cam_rot)
	
func _unhandled_input(_event : InputEvent) -> void:
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	
	if Input.is_action_just_pressed("z_target"):
		try_lock_on()
	
func _physics_process(delta : float) -> void:
	current_state.on_update(delta)
	
	var camera_dir : Vector2 = Input.get_vector("camera_left", "camera_right", "camera_up", "camera_down")
	
	cam_rot.x -= camera_dir.y * 2
	cam_rot.y -= camera_dir.x * 2
	cam_rot.x = clamp(cam_rot.x, -89.9, 90)
	camera.set_third_person_rotation_degrees(cam_rot)
	if camera.is_active():
		$SpringArm3D.global_rotation = camera.global_rotation
	else:
		camera.set_third_person_rotation_degrees($SpringArm3D.global_rotation_degrees)

func transition_state(newState : PlayerState) -> void:
	current_state.on_exit()
	current_state = newState
	current_state.on_enter(self)

func rotate_model(direction : Vector3) -> void:
	if lockon:
		var rot_pos = lockon_target.global_position
		rot_pos.y = self.global_position.y
		model.look_at(rot_pos, Vector3.UP, true)
	else:
		# workaround so when velocity.xz is 0 we don't rotate to angle 0
		if ((direction.x != 0) or (direction.z != 0)):
			model.global_rotation.y = lerp_angle(model.global_rotation.y, atan2(direction.x, direction.z), ROTATE_SPEED)

func align_with_camera(direction : Vector3) -> Vector3:
	var current_cam = get_viewport().get_camera_3d()
	return direction.rotated(Vector3.UP, current_cam.global_rotation.y)

func try_lock_on() -> void:	
	if not lockon:
		var lockon_targets : Array[Node] = get_tree().get_nodes_in_group("LockOnTargets")
		if lockon_targets.size() == 0:
			return
		
		lockon_targets = lockon_targets.filter(func(node): return node.process_mode != Node.ProcessMode.PROCESS_MODE_DISABLED)
		
		if lockon_targets.size() == 0:
			print_debug("nothing on screen")
			return
		
		lockon_targets = lockon_targets.filter(func(node): return self.global_position.distance_to(node.global_position) < lockon_distance)
		
		if lockon_targets.size() == 0:
			print_debug("nothing close enough")
			return
		
		lockon_targets.sort_custom(Global.sort_by_distance_to_screen_center)
		lockon_target = lockon_targets[0]
		
		lockon = true
		lockon_target.lock_on()
		
		$SpringArm3D/LockOnCamera.set_priority(30)
		$SpringArm3D.append_follow_targets(lockon_target)

		#lockon_camera.append_follow_targets(lockon_target)
	else:
		#cam_rot = lockon_camera.global_rotation_degrees
		
		lockon_target.lock_off()
		
		$SpringArm3D/LockOnCamera.set_priority(0)
		$SpringArm3D.erase_follow_targets(lockon_target)
		
		#lockon_camera.erase_follow_targets(lockon_target)
		lockon = false
