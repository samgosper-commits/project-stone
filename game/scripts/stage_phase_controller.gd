class_name StagePhaseController
extends Node
signal phase_changed(index:int,name:String)
@export var phase_names:Array[String]=["Departure","Countryside","Bridge","Tunnel","Locomotive Finale"]
@export var phase_duration:=35.0
var phase:=0
var timer:=0.0
func _ready()->void: timer=phase_duration
func _process(delta:float)->void:
	timer-=delta
	if timer<=0.0 and phase<phase_names.size()-1:
		phase+=1; timer=phase_duration; phase_changed.emit(phase,phase_names[phase])
