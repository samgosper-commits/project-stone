extends Node3D
@export var scroll_speed:=14.0
@export var wrap_length:=100.0
func _process(delta):
	for child in get_children():
		child.position.z+=scroll_speed*delta
		if child.position.z>50.0:child.position.z-=wrap_length
