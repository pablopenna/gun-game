extends State

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const THRESHOLD_TO_WALL_RUN = 1.0

@export var camera: PlayerCamera

func _ready():
	state_name = "player_move"

func enter(_data):
	print("MOVE")

func physics_process(delta: float) -> void:
	actor = actor as CharacterBody3D # Just for typing
	# Add the gravity.
	if not actor.is_on_floor():
		actor.velocity += actor.get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("player_jump") and actor.is_on_floor():
		actor.velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("player_left", "player_right", "player_forward", "player_backwards")
	
	var direction := (camera.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		actor.velocity.x = move_toward(actor.velocity.x, direction.x * SPEED, SPEED)
		actor.velocity.z = move_toward(actor.velocity.z, direction.z * SPEED, SPEED)
	else:
		actor.velocity.x = move_toward(actor.velocity.x, 0, SPEED)
		actor.velocity.z = move_toward(actor.velocity.z, 0, SPEED)
		
	if not actor.is_on_floor() and actor.is_on_wall():
		var wall_normal = actor.get_wall_normal()
		var direction_to_wall = wall_normal * -1
		var angle_to_wall = direction_to_wall.angle_to(direction)
		if angle_to_wall < THRESHOLD_TO_WALL_RUN:
			change_to_state.emit("player_wallstand", {"wall_normal": wall_normal})
	
	actor.move_and_slide()
