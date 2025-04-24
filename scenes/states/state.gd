class_name State extends Node

signal change_to_state(state_name: String, data: Dictionary)
var actor: Node
# Use this property rather than the node name to define the state name
# StateMachine uses this as the dict key where states are stored
var state_name: String 

func enter(data: Dictionary):
	pass
	
func process(delta):
	pass
	
func physics_process(delta):
	pass
	
func exit(new_state: State):
	pass
