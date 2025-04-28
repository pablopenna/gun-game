extends StateComponent

@export var player_stats: PlayerStats
@export var player_camera: PlayerCamera
@export var direction_component: Node

func component_physics_process(delta, actor):
	var direction: Vector3 = direction_component.direction
	
	if direction:
		#actor.velocity.x = move_toward(actor.velocity.x, direction.x * player_stats.move_speed, player_stats.move_speed)
		#actor.velocity.z = move_toward(actor.velocity.z, direction.z * player_stats.move_speed, player_stats.move_speed)
		actor.velocity.x = direction.x * player_stats.move_speed
		actor.velocity.z = direction.z * player_stats.move_speed
	else:
		#actor.velocity.x = move_toward(actor.velocity.x, 0, player_stats.move_speed)
		#actor.velocity.z = move_toward(actor.velocity.z, 0, player_stats.move_speed)
		actor.velocity.x = 0
		actor.velocity.z = 0
