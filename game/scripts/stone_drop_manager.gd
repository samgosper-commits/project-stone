class_name StoneDropManager
extends Node
@export var stone_scene:PackedScene
func spawn_stone(stone_id:int,at:Vector3):
	if stone_scene==null:return
	var s=stone_scene.instantiate();s.stone_id=stone_id;s.position=at+Vector3.UP*1.0
	get_tree().current_scene.add_child.call_deferred(s)
