class_name LockOnTarget extends Node3D

var enabler : VisibleOnScreenEnabler3D
var target_mesh : PackedScene = load("res://scenes/target_mesh.tscn")
var target : TargetMesh

func _ready() -> void:
	enabler = VisibleOnScreenEnabler3D.new()
	add_child(enabler)
	enabler.global_position = self.global_position
	enabler.enable_node_path = ".."
	enabler.aabb = AABB(Vector3(-1, -1, -1), Vector3(2, 2, 2))
	
	self.add_to_group("LockOnTargets")

func _exit_tree() -> void:
	self.remove_from_group("LockOnTargets")

func lock_on() -> void:
	target = target_mesh.instantiate()
	$"../../../../LockOnViewport".add_child(target)
	#add_child(target)
	#target.global_position = self.global_position
	target.initialize(self, get_viewport().get_camera_3d())
	target.anim.play("rotato")

func lock_off() -> void:
	target.anim.play("fadeout")
