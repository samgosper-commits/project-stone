class_name StonePlayerController
extends CharacterBody3D

@export var player_index: int = 0
@export var move_speed: float = 8.5
@export var acceleration: float = 34.0
@export var air_control: float = 0.55
@export var jump_velocity: float = 9.0
@export var gravity: float = 24.0
@export var rotation_speed: float = 16.0

var input_prefix := "p1"

func _ready() -> void:
	input_prefix = "p%d" % (player_index + 1)
	add_to_group("arena_players")

func _physics_process(delta: float) -> void:
	var input_vec := Input.get_vector(
		input_prefix + "_left",
		input_prefix + "_right",
		input_prefix + "_up",
		input_prefix + "_down"
	)
	var move_dir := Vector3(input_vec.x, 0.0, input_vec.y)
	var control := 1.0 if is_on_floor() else air_control
	var target := move_dir * move_speed
	velocity.x = move_toward(velocity.x, target.x, acceleration * control * delta)
	velocity.z = move_toward(velocity.z, target.z, acceleration * control * delta)

	if not is_on_floor():
		velocity.y -= gravity * delta
	elif Input.is_action_just_pressed(input_prefix + "_jump"):
		velocity.y = jump_velocity

	if move_dir.length_squared() > 0.01:
		var target_yaw := atan2(move_dir.x, move_dir.z)
		rotation.y = lerp_angle(rotation.y, target_yaw, rotation_speed * delta)

	move_and_slide()
