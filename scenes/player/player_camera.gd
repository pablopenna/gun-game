class_name PlayerCamera extends Camera3D

## Increase this value to give a slower turn speed
const CAMERA_TURN_SPEED = 100
var is_enabled = true

func _enter_tree():
	"""
	Hide the mouse when we start
	"""
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _leave_tree():
	"""
	Show the mouse when we leave
	"""
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func look_updown_rotation(new_rotation = 0):
	var toReturn = self.get_rotation().x + new_rotation
	## We don't want the player to be able to bend over backwards
	## neither to be able to look under their arse.
	## Here we'll clamp the vertical look to 90° up and down
	## NOTE: Rotations are in RADs
	toReturn = clamp(toReturn, PI / -2, PI / 2) 
	return toReturn

func look_leftright_rotation(new_rotation = 0):
	return self.get_rotation().y + new_rotation

func _unhandled_input(event: InputEvent):
	if event.is_action_released("player_pause"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		is_enabled = !is_enabled
		
	if not is_enabled:
		return
	
	if not event is InputEventMouseMotion:
		return

	var left_right_rotation = look_leftright_rotation(event.relative.x / -CAMERA_TURN_SPEED)
	var up_down_rotation = look_updown_rotation(event.relative.y / -CAMERA_TURN_SPEED)
	
	self.set_rotation(Vector3(fmod(up_down_rotation, 2*PI), fmod(left_right_rotation, 2*PI), self.get_rotation().z))
