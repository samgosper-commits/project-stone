class_name StoneInteractable
extends RigidBody3D

@export var display_name := "Object"
@export var throwable := true
@export var throw_speed := 14.0
@export var upward_throw := 4.5
var held_by: Node3D

func can_interact(_actor: Node3D) -> bool:
	return held_by == null

func pickup(actor: Node3D, socket: Node3D) -> void:
	held_by = actor
	freeze = true
	collision_layer = 0
	collision_mask = 0
	reparent(socket)
	position = Vector3.ZERO
	rotation = Vector3.ZERO

func throw_from(direction: Vector3) -> void:
	var root := get_tree().current_scene
	var old_transform := global_transform
	reparent(root)
	global_transform = old_transform
	freeze = false
	collision_layer = 1
	collision_mask = 1
	linear_velocity = direction.normalized() * throw_speed + Vector3.UP * upward_throw
	held_by = null
