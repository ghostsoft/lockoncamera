extends PlayerState

var movement : Vector3
var target_movement : Vector3

func on_enter(_player : PhysicsBody3D) -> void:
	super(_player)
	
	movement = player.velocity
	movement.y = 0
	
	target_movement = Vector3.ZERO

func on_update(_delta : float) -> void:
	var input_dir : Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	target_movement = Vector3(input_dir.x * player.GROUND_SPEED, 0, input_dir.y * player.GROUND_SPEED)
	target_movement = player.align_with_camera(target_movement)
	
	movement = movement.move_toward(target_movement, _delta * player.GROUND_SMOOTHING)
	
	player.velocity = movement
	
	player.move_and_slide()
	player.rotate_model(movement)

func on_exit() -> void:
	pass
