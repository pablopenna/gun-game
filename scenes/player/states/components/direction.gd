extends StateComponent

@export var player_camera: PlayerCamera

var input_dir: Vector2
var direction: Vector3

func component_physics_process(delta, actor):
	input_dir = Input.get_vector("player_left", "player_right", "player_forward", "player_backwards")
	direction = (player_camera.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
