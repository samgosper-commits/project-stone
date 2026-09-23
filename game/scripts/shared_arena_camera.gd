class_name SharedArenaCamera
extends Camera3D

@export var min_height: float = 15.0
@export var max_height: float = 25.0
@export var base_distance: float = 15.0
@export var spread_zoom_factor: float = 0.62
@export var position_smoothing: float = 5.5
@export var look_height: float = 1.2
@export var pitch_degrees: float = 40.0

var players: Array[Node3D] = []

func _ready() -> void:
	current = true

func _process(delta: float) -> void:
	players.assign(get_tree().get_nodes_in_group("arena_players"))
	if players.is_empty():
		return

	var centre := Vector3.ZERO
	for player in players:
		centre += player.global_position
	centre /= players.size()

	var max_spread := 0.0
	for player in players:
		max_spread = max(max_spread, player.global_position.distance_to(centre))

	var height := clamp(min_height + max_spread * spread_zoom_factor, min_height, max_height)
	var pitch := deg_to_rad(pitch_degrees)
	var desired := centre + Vector3(0.0, sin(pitch) * height, cos(pitch) * base_distance + max_spread * 0.35)
	global_position = global_position.lerp(desired, 1.0 - exp(-position_smoothing * delta))
	look_at(centre + Vector3.UP * look_height, Vector3.UP)
