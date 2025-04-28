extends State

const SPEED = 5.0
const JUMP_VELOCITY = 50
const STANDING_ROTATION = PI/2

@export var camera: PlayerCamera
@export var raycast: WallRaycast

var _rotation_axis
var _wall_normal

func _ready():
	state_name = "player_wallrun"

func _process_wall():
	if not actor.is_on_wall():
		return
	_wall_normal = actor.get_wall_normal().normalized()
	_rotation_axis = Vector3.UP.cross(_wall_normal).normalized()
	actor.rotate(_rotation_axis, STANDING_ROTATION)
	camera.rotate(_rotation_axis, -STANDING_ROTATION) # This is so that the camera keeps aiming at the same place
	camera.rotation.z = 0 # HACK: adjustment of the adjustment. Z rotation is like tilting your head side-ways 
	
	## HACK: when rotating it may stop colliding with the wall.
	# We use a raycast to detect the wall and make sure it is colliding with it
	var wall_contact_point = raycast._detect_wall(_wall_normal)
	if wall_contact_point == null:
		return
	actor.position = wall_contact_point

# Does not work as when the actor is away from the wall it instantly transitions to another state
# and this does not have time to apply its effects
func _adjust_to_wall():
	actor = (actor as CharacterBody3D)
	if actor.is_on_wall():
		_wall_normal = actor.get_wall_normal()
	## HACK: when rotating it may stop colliding with the wall.
	# We use a raycast to detect the wall and make sure it is colliding with it
	var wall_contact_point = raycast._detect_wall(_wall_normal)
	if wall_contact_point == null:
		return
	print("adjusting to wall")
	actor.velocity += 500 * (actor as CharacterBody3D).global_position.direction_to(wall_contact_point).normalized()

func enter(_data):
	print("WALLRUN")
	_process_wall()

func exit(_state):
	actor.rotate(_rotation_axis, -STANDING_ROTATION)
	camera.rotate(_rotation_axis, STANDING_ROTATION)
	camera.rotation.z = 0
	
func physics_process(delta: float) -> void:
	actor = actor as CharacterBody3D
		
	if Input.is_action_just_pressed("player_jump"):
		actor.velocity = _wall_normal * JUMP_VELOCITY

	var input_dir := Input.get_vector("player_left", "player_right", "player_forward", "player_backwards")
	if input_dir == Vector2.ZERO:
		change_to_state.emit("player_wallstand")
	var direction := (camera.global_transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	actor.velocity = direction * SPEED
	print("before")
	print(actor.velocity)
	_adjust_to_wall()
	print("after")
	print(actor.velocity)
	
	actor.move_and_slide()
	
	if not actor.is_on_wall():
		change_to_state.emit("player_move")
