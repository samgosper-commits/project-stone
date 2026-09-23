extends Node

const ACTIONS := ["left","right","up","down","jump","attack","action","evade","power"]
const BUTTONS := {
	"jump": JOY_BUTTON_A,
	"attack": JOY_BUTTON_X,
	"action": JOY_BUTTON_B,
	"evade": JOY_BUTTON_Y,
	"power": JOY_BUTTON_RIGHT_SHOULDER
}

func _ready() -> void:
	for p in range(1,5):
		for action in ACTIONS:
			var name := "p%d_%s" % [p,action]
			if not InputMap.has_action(name): InputMap.add_action(name)
		_add_pad_bindings(p-1,name,action)
	_add_keyboard()

func _add_pad_bindings(device:int, action_name:String, action:String) -> void:
	if action=="left" or action=="right":
		var e:=InputEventJoypadMotion.new(); e.device=device; e.axis=JOY_AXIS_LEFT_X; e.axis_value=-1.0 if action=="left" else 1.0; InputMap.action_add_event(action_name,e)
	elif action=="up" or action=="down":
		var e:=InputEventJoypadMotion.new(); e.device=device; e.axis=JOY_AXIS_LEFT_Y; e.axis_value=-1.0 if action=="up" else 1.0; InputMap.action_add_event(action_name,e)
	elif BUTTONS.has(action):
		var b:=InputEventJoypadButton.new(); b.device=device; b.button_index=BUTTONS[action]; InputMap.action_add_event(action_name,b)

func _add_keyboard()->void:
	var keys={"p1_left":KEY_A,"p1_right":KEY_D,"p1_up":KEY_W,"p1_down":KEY_S,"p1_jump":KEY_SPACE,"p1_attack":KEY_J,"p1_action":KEY_K,"p1_evade":KEY_L,"p1_power":KEY_I}
	for name in keys:
		var e:=InputEventKey.new(); e.physical_keycode=keys[name]; InputMap.action_add_event(name,e)
