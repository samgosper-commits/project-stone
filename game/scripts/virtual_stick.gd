extends Node2D

@export var radius:=135.0
@export var deadzone:=0.16
var touch_id:=-1
var stick_vector:=Vector2.ZERO

func _ready()->void:
	add_to_group("virtual_sticks")
	queue_redraw()

func _input(event:InputEvent)->void:
	if event is InputEventScreenTouch:
		if event.pressed and touch_id==-1 and event.position.distance_to(global_position)<radius*1.3:
			touch_id=event.index
			_set_vector(event.position-global_position)
		elif not event.pressed and event.index==touch_id:
			_release()
	elif event is InputEventScreenDrag and event.index==touch_id:
		_set_vector(event.position-global_position)

func _set_vector(offset:Vector2)->void:
	stick_vector=offset.limit_length(radius)/radius
	if stick_vector.length()<deadzone:
		PrototypeInputSetup.touch_move_vector=Vector2.ZERO
	else:
		# A single thumb can reach every diagonal. Pads retain full analog input.
		var angle:=snappedf(stick_vector.angle(),PI/4.0)
		PrototypeInputSetup.touch_move_vector=Vector2.from_angle(angle)
	queue_redraw()

func _release()->void:
	touch_id=-1
	stick_vector=Vector2.ZERO
	PrototypeInputSetup.touch_move_vector=Vector2.ZERO
	queue_redraw()

func _notification(what:int)->void:
	if what==NOTIFICATION_APPLICATION_FOCUS_OUT:_release()

func _exit_tree()->void:
	PrototypeInputSetup.touch_move_vector=Vector2.ZERO

func _draw()->void:
	draw_circle(Vector2.ZERO,radius,Color(0.025,0.065,0.12,0.72))
	draw_arc(Vector2.ZERO,radius,0,TAU,64,Color(0.5,0.83,0.93,0.7),3,true)
	for i in range(8):
		var axis:=Vector2.from_angle(i*PI/4.0)
		draw_line(axis*radius*0.78,axis*radius*0.9,Color(0.7,0.9,1,0.8),5,true)
	draw_circle(stick_vector*radius*0.65,47,Color(0.2,0.72,0.91,0.9))
