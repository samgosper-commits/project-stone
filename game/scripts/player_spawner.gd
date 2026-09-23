class_name PlayerSpawner
extends Node3D

@export var player_scene: PackedScene
@export_range(1, 4) var local_player_count: int = 4
@export var spawn_radius: float = 3.0

func _ready() -> void:
	if player_scene == null:
		push_error("PlayerSpawner requires a player_scene.")
		return
	for i in local_player_count:
		var player := player_scene.instantiate()
		player.player_index = i
		var angle := TAU * float(i) / float(local_player_count)
		player.position = Vector3(cos(angle), 0.75, sin(angle)) * spawn_radius
		add_child(player)
