class_name PlayerSpawner
extends Node3D
@export var player_scene:PackedScene
@export_range(1,4)var local_player_count:=4
@export var spawn_radius:=3.0
func _ready()->void:
	if player_scene==null:push_error("PlayerSpawner requires player_scene");return
	var pads:=Input.get_connected_joypads()
	var count:=min(local_player_count,max(1,pads.size()))
	# Alpha convenience: if four pads are absent, still spawn requested dummies for camera/combat testing.
	if "--connected-only" not in OS.get_cmdline_user_args():count=local_player_count
	for i in count:
		var p:=player_scene.instantiate();p.player_index=i
		var a:=TAU*float(i)/float(count);p.position=Vector3(cos(a),0.75,sin(a))*spawn_radius;add_child(p)
