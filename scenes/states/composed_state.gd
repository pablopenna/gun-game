class_name ComposedState extends State

func _ready():
	# Workaround as I cannot export attribute from parent
	state_name = name

func process(delta):
	var children = self.get_children()
	for component in children:
		if component is not StateComponent:
			continue
		component.component_process(delta, actor)
	
func physics_process(delta):
	var children = self.get_children()
	for component in children:
		if component is not StateComponent:
			continue
		component.component_physics_process(delta, actor)
