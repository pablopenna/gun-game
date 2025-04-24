class_name StateMachine extends Node

var _states: Dictionary
var current_state: State = initial_state
@export var initial_state: State
@export var actor: Node

signal state_changed(new_state_name: String, old_state_name: String)

func _ready():
	_states = get_children_as_state_dictionary()
	initialize_states(_states)
	
	on_change_to_state(initial_state.state_name)

func _process(delta):
	current_state.process(delta)

func _physics_process(delta):
	current_state.physics_process(delta)

func get_children_as_state_dictionary() -> Dictionary:
	var children: Array[Node] = self.get_children()
	var states: Dictionary = {}
	
	for child in children as Array[State]:
		states[child.state_name] = child
		
	return states
	
func initialize_states(states: Dictionary):
	for stateKey in states:
		var state: State = states[stateKey]
		
		state.change_to_state.connect(on_change_to_state)
		state.actor = self.actor

func on_change_to_state(new_state_name: String, data: Dictionary = {}):
	var old_state = current_state
	var new_state = _states[new_state_name]
	if old_state != null:
		old_state.exit(new_state)
	current_state = new_state
	new_state.enter(data)
	
	state_changed.emit(new_state_name, old_state.state_name if old_state else null)
