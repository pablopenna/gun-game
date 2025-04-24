extends State

const SPEED = 5.0
const JUMP_VELOCITY = 50
const THRESHOLD_TO_WALL_RUN = 1.0
const GRAVITY_MODIFIER = 0.1
const STANDING_ROTATION = PI/4 # RAD

@export var camera: PlayerCamera
@export var raycast: WallRaycast

var _rotation_axis

func _ready():
	state_name = "player_wallstand"

func _adjust_to_wall():
	if not actor.is_on_wall():
		return
	
	var wall_normal = actor.get_wall_normal()
	_rotation_axis = Vector3.UP.cross(wall_normal).normalized()
	
	actor.rotate(_rotation_axis, STANDING_ROTATION)
	
	camera.rotate(_rotation_axis, -STANDING_ROTATION) # This is so that the camera keeps aiming at the same place
	camera.rotation.z = 0 # HACK: adjustment of the adjustment. Z rotation is like tilting your head side-ways 
	
	## HACK: when rotating it may stop colliding with the wall.
	# We use a raycast to detect the wall and make sure it is colliding with it
	var wall_contact_point = raycast._detect_wall(wall_normal)
	if wall_contact_point == null:
		return null
	actor.position = wall_contact_point

func enter(data: Dictionary):
	_adjust_to_wall()
	actor.velocity = Vector3.ZERO
	
func exit(_state):
	_rotation_axis = _rotation_axis.normalized()
	actor.rotate(_rotation_axis, -STANDING_ROTATION)
	camera.rotate(_rotation_axis, STANDING_ROTATION)
	camera.rotation.z = 0
	
func physics_process(delta: float) -> void:
	actor = actor as CharacterBody3D
	
	if not actor.is_on_wall():
		change_to_state.emit("player_move")
		
	if Input.is_action_just_pressed("player_jump"):
		actor.velocity = actor.get_wall_normal() * JUMP_VELOCITY
	
	var input_dir := Input.get_vector("player_left", "player_right", "player_forward", "player_backwards")
	if input_dir != Vector2.ZERO:
		change_to_state.emit("player_wallrun")
	
	actor.move_and_slide()
