class_name WallRaycast extends RayCast3D

const RAY_LENGTH = 5

func _detect_wall(wall_normal: Vector3):
	# HACK: For some reason, manual rotations to Raycast do not apply, so
	# a workaround for it is setting "top_level" to true under Transform
	# and then updating the position manually here.
	self.global_position = self.get_parent().global_position 
	
	self.target_position = (wall_normal * -1).normalized() * RAY_LENGTH
	self.force_raycast_update() # If raycast is disabled this allows us to do a single collision check
	if self.is_colliding():
		return self.get_collision_point()
	else:
		return null
