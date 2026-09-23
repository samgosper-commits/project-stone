class_name StagePhaseController
extends Node
signal phase_changed(index:int,name:String)
@export var phase_names:Array[String]=["Departure","Countryside","Bridge","Tunnel","Locomotive Finale"]
@export var phase_duration:=35.0
var phase:=0
var timer:=0.0
func _ready()->void:timer=phase_duration;phase_changed.emit(phase,phase_names[phase])
func _process(delta:float)->void:
	timer-=delta
	if timer<=0.0 and phase<phase_names.size()-1:
		phase+=1;timer=phase_duration;phase_changed.emit(phase,phase_names[phase]);_apply_phase()
func _apply_phase()->void:
	match phase:
		1: get_tree().call_group("train_props","set_meta","world_speed",1.2)
		2: get_tree().call_group("train_props","set_meta","world_speed",1.5)
		3: get_tree().call_group("arena_players","set_meta","tunnel_phase",true)
		4: get_tree().call_group("arena_players","set_meta","finale_phase",true)
