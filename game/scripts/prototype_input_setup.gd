extends Node
const ACTIONS := ["left","right","up","down","jump","attack","action","evade","power"]
func _ready() -> void:
	for player in range(1,5):
		for action in ACTIONS:
			var n:="p%d_%s"%[player,action]
			if not InputMap.has_action(n): InputMap.add_action(n)
	_add_key("p1_left",KEY_A); _add_key("p1_right",KEY_D); _add_key("p1_up",KEY_W); _add_key("p1_down",KEY_S)
	_add_key("p1_jump",KEY_SPACE); _add_key("p1_attack",KEY_J); _add_key("p1_action",KEY_K); _add_key("p1_evade",KEY_L); _add_key("p1_power",KEY_I)
func _add_key(action:StringName,keycode:Key)->void:
	if not InputMap.action_get_events(action).is_empty(): return
	var e:=InputEventKey.new(); e.physical_keycode=keycode; InputMap.action_add_event(action,e)
