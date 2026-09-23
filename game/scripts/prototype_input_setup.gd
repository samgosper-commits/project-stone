extends Node

const ACTIONS := ["left", "right", "up", "down", "jump", "attack", "heavy", "grab", "evade"]

func _ready() -> void:
	for player in range(1, 5):
		for action in ACTIONS:
			var action_name := "p%d_%s" % [player, action]
			if not InputMap.has_action(action_name):
				InputMap.add_action(action_name)

	# Keyboard fallback for Player 1 so the prototype is immediately testable.
	_add_key("p1_left", KEY_A)
	_add_key("p1_right", KEY_D)
	_add_key("p1_up", KEY_W)
	_add_key("p1_down", KEY_S)
	_add_key("p1_jump", KEY_SPACE)
	_add_key("p1_attack", KEY_J)
	_add_key("p1_heavy", KEY_K)
	_add_key("p1_grab", KEY_L)
	_add_key("p1_evade", KEY_SHIFT)

func _add_key(action: StringName, keycode: Key) -> void:
	if not InputMap.action_get_events(action).is_empty():
		return
	var event := InputEventKey.new()
	event.physical_keycode = keycode
	InputMap.action_add_event(action, event)
