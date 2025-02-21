extends CharacterBody3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#self.velocity += $AnimationPlayer.get_root_motion_position().rotated(Vector3.UP, 90)
	#self.velocity = $AnimationPlayer.get_root_motion_position_accumulator()
	#move_and_slide()
	self.global_position += $AnimationPlayer.get_root_motion_position().rotated(Vector3.UP, rotation.y)
