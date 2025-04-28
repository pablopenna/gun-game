extends StateComponent

@export var player_stats: PlayerStats

func component_physics_process(delta, actor):
	if Input.is_action_just_pressed("player_jump") and actor.is_on_floor():
		actor.velocity.y += player_stats.jump_speed
