extends StateComponent

@export var player_stats: PlayerStats
@export var player_camera: PlayerCamera
@export var direction_component: Node
@export var attach_to_wall_state: State

func component_physics_process(delta, actor):
	if actor.is_on_floor():
		return
	if not actor.is_on_wall():
		return
	
	var wall_normal = actor.get_wall_normal()
	var direction_to_wall = wall_normal * -1
	var angle_to_wall = direction_to_wall.angle_to(direction_component.direction)
	if angle_to_wall < player_stats.threshold_to_wall_run:
		get_parent().change_to_state.emit(attach_to_wall_state.state_name, {"wall_normal": wall_normal})
