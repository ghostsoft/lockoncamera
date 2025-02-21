class_name TargetMesh extends MeshInstance3D

# Rotation in radians
@export var rotato : float = PI
@onready var anim : AnimationPlayer = $AnimationPlayer

var _parent : Node3D
var _camera_ref : Camera3D

@onready var camera : Camera3D = $Camera3D

func initialize(parent, camera_ref) -> void:
	_parent = parent
	_camera_ref = camera_ref

func _process(_delta: float) -> void:
	self.global_position = _parent.global_position
	camera.global_position = _camera_ref.global_position
	camera.global_rotation = _camera_ref.global_rotation
	
	# Get camera coordinates
	var look_pos : Vector3 = camera.global_position
#
	look_pos.y = global_position.y

	look_at(look_pos, camera.global_transform.basis.y, true)
	rotate_object_local(Vector3.FORWARD, rotato)
