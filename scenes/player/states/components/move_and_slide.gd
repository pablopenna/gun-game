extends StateComponent

func component_physics_process(delta, actor):
	actor.move_and_slide()
