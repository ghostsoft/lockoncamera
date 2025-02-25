extends SpringArm3D

@onready var camera : PhantomCamera3D = $LockOnCamera

@export var _follow_targets : Array[Node3D]

var follow_offset = Vector3(0.2, 1.0, 0)
var follow_distance = 10.0
var auto_follow_distance = true

var auto_follow_distance_min = 0.0 # 5.0 i assume these values have to be
var auto_follow_distance_max = 2.0 # 12.0 much smaller due to the spring arm
var auto_follow_distance_divisor = 10.0

var follow_position : Vector3

func _ready() -> void:
	self.top_level = true

func _physics_process(_delta: float) -> void:
	if _follow_targets.size() > 1:
		# code copied from LookAtMode.SIMPLE
		var direction: Vector3 = (_follow_targets[1].global_position - global_position).normalized()
		var target_basis: Basis = Basis.looking_at(direction)
		var target_quat: Quaternion = target_basis.get_rotation_quaternion().normalized()
		quaternion = target_quat
		if rotation_degrees.x < -20:
			rotation_degrees.x = -20
		
	# code copied from FollowMode.GROUP
	var bounds: AABB = AABB(_follow_targets[0].global_position, Vector3.ZERO)
	for target in _follow_targets:
		bounds = bounds.expand(target.global_position)
	var distance: float
	if auto_follow_distance:
		distance = lerpf(auto_follow_distance_min, auto_follow_distance_max, bounds.get_longest_axis_size() / auto_follow_distance_divisor)
		distance = clampf(distance, auto_follow_distance_min, auto_follow_distance_max)
	else:
		distance = follow_distance

	follow_position = \
		bounds.get_center() + \
		follow_offset + \
		get_transform().basis.z * \
		Vector3(distance, distance, distance)
	
	self.global_position = follow_position

func append_follow_targets(target : Node3D) -> void:
	self.add_excluded_object(target)
	_follow_targets.append(target)

func erase_follow_targets(target : Node3D) -> void:
	self.remove_excluded_object(target)
	_follow_targets.erase(target)

func set_priority(priority : int) -> void:
	camera.set_priority(priority)
