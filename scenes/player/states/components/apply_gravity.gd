extends StateComponent

func component_physics_process(delta, actor):
	if not actor.is_on_floor():
		actor.velocity += actor.get_gravity() * delta
