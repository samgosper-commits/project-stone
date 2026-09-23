class_name PlayerSpawner
extends Node3D
@export var player_scene:PackedScene
@export_range(1,4)var local_player_count:int=4
@export var spawn_radius:float=3.0
func _ready()->void:
 if player_scene==null:push_error("PlayerSpawner requires player_scene");return
 var pads:Array[int]=Input.get_connected_joypads()
 var count:int=mini(local_player_count,maxi(1,pads.size()))
 if "--connected-only" not in OS.get_cmdline_user_args():count=local_player_count
 for i:int in range(count):
  var p:Node=player_scene.instantiate()
  p.set("player_index",i)
  var a:float=TAU*float(i)/float(count)
  p.set("position",Vector3(cos(a),0.75,sin(a))*spawn_radius)
  add_child(p)
