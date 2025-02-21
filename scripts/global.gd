extends Node


func sort_by_screen_right() -> void:
	pass

func sort_by_distance_to_screen_center(a : Node3D, b : Node3D) -> bool:
	if distance_to_screen_center(a) < distance_to_screen_center(b):
		return true
	return false

func distance_to_screen_center(node : Node3D) -> float:
	var camera : Camera3D = node.get_viewport().get_camera_3d()
	
	var viewport_center : Vector2 = get_viewport().get_visible_rect().size / 2.0
	
	var node_pos : Vector2 = camera.unproject_position(node.global_position)
	
	return node_pos.distance_to(viewport_center)
