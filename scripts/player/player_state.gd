class_name PlayerState extends Node

var player : PhysicsBody3D

func on_enter(_player : PhysicsBody3D) -> void:
	player = _player

func on_update(_delta : float) -> void:
	pass

func on_input(_event : InputEvent) -> void:
	pass

func on_exit() -> void:
	pass
